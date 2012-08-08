class TimesheetOptionsController < ApplicationController
  before_filter :require_user
  before_filter :find_contract, :only => [:new, :update, :edit, :create]
  before_filter :find_users, :only => [:edit, :update]

  def find_users
    @users = User.find_users_for_timesheet_option(@contract.id)
      if current_user.contract_default.allow_timesheet
        @users = @users + current_user.to_a
      end
  end
  
  def new
    @timesheet_option = TimesheetOption.new
    if params[:contract_id].eql?("-")
      @users = User.find_all_by_id(current_user.id)
    else
      @users = User.find_users_for_timesheet_option(@contract.id)
      if current_user.contract_default.allow_timesheet
        @users = @users + current_user.to_a
      end
    end
  end

  def create
    unless params[:timesheet_option].blank?
      timesheet_id = []
      params[:timesheet_option].each do |p|
        @timesheet_option = TimesheetOption.new(p)
        @timesheet_option.save!
        timesheet_id << @timesheet_option.id
      end
    end
    session[:timesheet_id] = timesheet_id.join("-")
    @contract              = Contract.new()
    if params[:contract_type].eql?('standard')
      redirect_to new_contract_path
    else
      redirect_to new_contract_sub_contract_path
    end
  end

  def edit
  end

  def update
    unless params[:timesheet_option].blank?
      params[:timesheet_option].each do |t|
        ts = TimesheetOption.find(t[:id])
        ts.update_attributes(t)
      end
      redirect_to edit_contract_path(@contract)
    else
    end
  end

  def find_contract
    if !params[:contract_id].blank? && !params[:contract_id].eql?("-")
      @contract = Contract.find(params[:contract_id])
    end
  end

end
