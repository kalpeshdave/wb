class SubContractsController < ApplicationController
  before_filter :require_user
  before_filter :find_company
  before_filter :find_contract, :only => [:new, :new_timesheet_option, :create_timesheet_option]
  
  def new
    redirect_to contract_path(@contract) and return unless @contract.already_sub_contract_created?(current_user.id)
    @parent = current_user.recepients.find(params[:contract_id])
    @parent.is_template           = false
    @parent.description           = ""
    @parent.long_description      = ""
    @parent.is_recipient          = false
    @parent.country               = ""
    @parent.state                 = ""
    @parent.city                  = ""
    @parent.recepient_id          = ""
    @parent.recepient_company_id  = ""

    @contract = @parent.clone
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
    Contract.transaction do
      if @contract.save
        flash[:notice] = t("contracts.success")
        if @contract.status.eql?("proposed")
          redirect_to new_contract_propose_contract_path(@contract)
        else
          redirect_to edit_contract_path(@contract)
        end
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
    @contract = Contract.find(params[:id])
    @parent = Contract.find_by_parent_id(@contract.parent_id)
  end

  
  
  def find_contract
    if !params[:contract_id].blank? && !params[:contract_id].eql?("-")
      @contract = Contract.find_by_contract_number(params[:contract_id].split("-").last)
    end
  end

  def new_timesheet_option
    @timesheet_option = TimesheetOption.new
    @users            = User.find_all_by_id(current_user.id)
    if @contract
      @users  = User.find_users_for_timesheet_option(@contract.id)
      if current_user.contract_default.allow_timesheet
        @users = @users + current_user.to_a
      end
    else
      @users = User.find_all_by_id(current_user.id)
    end
  end

  def create_timesheet_option
    unless params[:timesheet_option].blank?
      timesheet_id = []
      params[:timesheet_option].each do |p|
        @timesheet_option = TimesheetOption.new(p)
        @timesheet_option.save!
        timesheet_id << @timesheet_option.id
      end
    end
    session[:timesheet_id] = timesheet_id.join("-")
    #@contract              = Contract.new()
    redirect_to new_contract_sub_contract_path
  end

  private

  def find_company
    @company = CompanyUser.find(:first, :conditions => ['user_id = ?', current_user.id], :order => 'created_at DESC')
  end
end
