class PasswordResetsController < ApplicationController
  before_filter :require_no_user 
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  
  def new
    render
  end

  def secret
   @user = User.find_by_email(params[:email])
#   raise @user.inspect
   unless @user
     flash[:notice] = "No user found with the email address."
     redirect_to root_url
   end
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user.secret_answer.downcase == params[:secret_answer].downcase
      @user.deliver_password_reset_instructions!
      flash[:notice] = t("password_resets.success")
      redirect_to root_url
    else
      flash[:notice] = t("password_resets.failure")
      redirect_to secret_url(:email => @user.email)
    end
  end

  def edit
    render
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
      if @user.save
        flash[:notice] = t("users.password_success")
        redirect_to account_url
      else
        render :action => :edit
      end
  end

  private
  
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    
    unless @user
      flash[:notice] = t("password_resets.failure_update")
      redirect_to root_url
    end
  end
end
