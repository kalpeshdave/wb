class ContractsController < ApplicationController
  before_filter :require_user
  before_filter :find_contract, :only => [:edit, :update]
  before_filter :require_company, :only => [:new]
  before_filter :permission_check,  :only => [:show]
  before_filter :security_check,    :only => [:edit, :update, :destroy]
  before_filter :edit_url, :only => [:edit]
  before_filter :find_company

  def recipient_detail
    partial_name = params[:checked].eql?('true') ? "company_drop_down" : "default_company"
    render :json => { :data => render_to_string(:partial => partial_name) }
  end

  def edit_url
    redirect_to contract_path(@contract) and return if @contract.creator.eql?(current_user) && @contract.status.eql?("approved")
  end
  
  def show; end

  def index
    unless params[:status].blank?
      if params[:status] == "weekly_recieved" or params[:status] == "monthly_recieved"
        @contracts = current_user.send(params[:status]).paginate(:page => params[:page], :per_page => Contract::PER_PAGE)
      else
        case params[:status]
        when "weekly_recepient_contracts"
          @contracts = Contract.weekly_recepient_contracts(current_user.id).paginate(:page => params[:page], :per_page => Contract::PER_PAGE)
        when "monthly_recepient_contracts"
          @contracts = Contract.monthly_recepient_contracts(current_user.id).paginate(:page => params[:page], :per_page => Contract::PER_PAGE)
        else
          @contracts = current_user.contracts.send(params[:status]).paginate(:page => params[:page], :per_page => Contract::PER_PAGE)
       end
      end
    else
      @contracts = Contract.find_contract(current_user.id).paginate(:page => params[:page], :per_page => Contract::PER_PAGE)
    end
  end

  def new
    unless params[:template_id].blank?
      contract_clone                  = Contract.find params[:template_id]
      contract_clone.contract_number  = nil
      contract_clone.is_template      = false
      contract_clone.is_recipient      = false
      
      @contract = contract_clone.clone
    else
      @contract = Contract.new()
    end
    @users = User.find_users_for_timesheet_option(@contract.id)
    if current_user.contract_default.allow_timesheet
        @users = @users + current_user.to_a
      end

  end


  def create
    params[:contract].merge!(:post_type => params[:commit])
    @contract = current_user.contracts.build(params[:contract])
    if @contract.is_recipient?
      @contract.approved!
    end
    #@contract.timesheet_options.build({:user_id => current_user.id, :visibility => "approver"}) if current_user.contract_default.allow_timesheet
    Contract.transaction do
      if @contract.save
        # kalpesh the below mentioned code push it to the contract model that is after save.....
        if session[:timesheet_id]
          session[:timesheet_id].split("-").each do |s|
            ts = TimesheetOption.find(s)
            ts.contract_id = @contract.id
            ts.save(false)
          end
        end
        flash[:notice] = t("contracts.success")
        if params[:commit].eql?("Create & Propose")
          redirect_to new_contract_propose_contract_path(@contract)
        else
          redirect_to edit_contract_path(@contract)
        end
        session[:timesheet_id] = nil
      else
        @users = User.find_users_for_timesheet_option(@contract.id)
    if current_user.contract_default.allow_timesheet
        @users = @users + current_user.to_a
      end
        render :action => 'new'
      end
    end
  end

  def edit
    if @contract.status.eql?("proposed")
      redirect_to contract_url(@contract)
    end
    if !@contract.parent_id.nil?
      @parent = Contract.find_by_parent_id(@contract.parent_id)
     
    end
  end

  def update
    params[:contract].merge!(:post_type => params[:commit])
    if @contract.update_attributes(params[:contract])
      flash[:notice] = t("contracts.update_success")
      if params[:commit].eql?("Update & Propose")
        redirect_to new_contract_propose_contract_path(@contract)
      else
        if params[:commit].eql?("Update & Post")
          @contract.post!
        end
        redirect_to edit_contract_path(@contract)
      end
    else
      render :edit
    end
  end

  def recepient_reason
    @contract = Contract.find(params[:id])
    render
  end

  def approve_reject
    @contract = Contract.find(params[:id])
    
    if params[:commit].eql?("Reject")
      @contract.rejected!
      UserNotifier.deliver_reject_contract(@contract, params[:reason])
      flash[:notice] = "Contract has been Rejected"
      redirect_to contract_dashboard_path
    else
      @contract.approved!
      UserNotifier.deliver_approve_contract(@contract, params[:reason])
      flash[:notice] = "Contract has been Accepted"
      redirect_to contract_dashboard_path
    end
  end

  def download_file
    @file = Attachment.find(params[:id])
    send_file "public/system/avatars/#{@file.id}/original/#{@file.avatar_file_name}"
  end

  def delete_attachment
    @contract = Contract.find(params[:contract_id])
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    redirect_to edit_contract_path(@contract)
  end

  def get_recipients
    if params[:recepient_company_id].blank?
      @users = []
    else
      @company = Company.find(params[:recepient_company_id])
      @users_companies = @company.find_users(current_user.id)
      p "---------------"
      p @users_companies 
      p "---------------"
      @users = @users_companies
#      if @users_companies
#        @users_companies.each do |uc|
#          user = User.find(uc.user_id)
#          if @users.include?(user)
#            next
#          else
#            @users << user
#          end
#        end
#      end
    end
    json = { :get_recipients_page => render_to_string(:partial => "rec_contacts", :object => @users) }
    render :json => json
  end

  def get_clients
    if params[:client_company_id].blank?
      @users = []
    else
      @company = Company.find(params[:client_company_id])
      @users_companies = @company.company_users
      @users = []
      if @users_companies
        @users_companies.each do |uc|
          user = User.find(uc.user_id)
          if @users.include?(user)
            next
          else
            @users << user
          end
        end
      end
    end
    json = { :get_clients_page => render_to_string(:partial => "client_contacts", :object => @users) }
    render :json => json
  end

  def recipient_create
    json = { :recipient_create_page => render_to_string(:partial => "recepient_contact", :object => Contract.new ) }
    render :json => json
  end

  def timesheet_option; end

  def update_timesheet_option; end

  def update_is_template
    @contract = Contract.find(:first, :include => [:creator], :conditions => ["id = ?", params[:id]])
    value = params[:is_template].eql?("false") ? 0 : 1
    @contract.update_attributes(:is_template => value)
    render :nothing => true
  end

  def get_time_units
    unless params[:time_base_id].nil?
      @time_base = TimeBase.find(params[:time_base_id])
      case params[:time_base_id]
      when "1"
        @time_units = TimeUnit.find(:all, :limit => 3)
      when "2"
        @time_units = TimeUnit.find(:all, :limit => 4)
      when "3"
        @time_units = TimeUnit.find(:all, :limit => 5)
      else
        @time_units = TimeUnit.find(:all)
      end
      json = { :get_time_units_page => render_to_string(:partial => "time_units", :object => @time_units) }
      render :json => json
    end
  end


  private
  
  def find_contract
    @contract = current_user.contracts.find(params[:id])
  end

  def permission_check
    @contract = Contract.find(:first, :include => [:creator, :recepient, :company, :recepient_company], :conditions => ["id = ?", params[:id]])
    forbidden unless @contract.viewable?(current_user)
  end

  def security_check
    forbidden unless can_edit?(@contract)
  end

  def find_company
    @company = CompanyUser.find(:first, :conditions => ['user_id = ?', current_user.id], :order => 'created_at DESC')
  end

end
