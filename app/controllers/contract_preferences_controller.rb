class ContractPreferencesController < ApplicationController
  before_filter :require_user

  def edit
    
  end

  def update
    user = User.find(params[:user_id])
    redirect_to edit_user_contract_preference_path(current_user) and return unless user.eql?(current_user)
    if current_user.update_attributes(params[:user])
      flash[:notice] = t("contracts.success_contract_preferences")
      redirect_to edit_user_contract_preference_path(current_user)
    else
      render :edit
    end
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

end
