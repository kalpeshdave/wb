class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :contact_info, :password_settings, :user_access, :update_contact_info]
  before_filter :fetch, :only => [:show, :edit, :update, :contact_info, :edit, :password_settings, :update_password, :user_access, :update_contact_info, :edit_address, :update_address, :delete_address]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    #if validate_recap(params, @user.errors) && @user.save_without_session_maintenance
    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      flash[:notice] = t("signup.success")
      redirect_to root_url
    else
      render :action => :new
    end
  end

  def show
    
  end

  def contact_info; end

  def update_contact_info
    # Unset old primary address, if changed
    params[:user][:new_addresses_attributes].each do |p|
      if p[:is_primary]
        Address.update_all("is_primary=false", ["addressable_type='User' AND addressable_id=?", @user.id])
      end
    end
    if @user.update_attributes(params[:user])      
      flash[:notice] = t("users.success_contact_update")
      redirect_to contact_info_url
    else
      render :action => :contact_info
    end
  end

  def edit

  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = t("users.success_update")
      redirect_to account_url
    else
      render :action => :show
    end
  end

  def password_settings; end

  def update_password
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
        flash[:notice] = t("users.password_success")
        redirect_to account_url
      else
        render :action => :password_settings
      end
  end
  
  def user_access
    @user.user_preference.contact_me  = params[:contact_me]
    @user_access_lists                = current_user.user_access_lists.all
    @user_access_lists.each {|a| a.destroy }
    
    if @user.user_preference.save
      json = { :user_access_page => render_to_string(:partial => "user_access") }
      render :json => json
    else
      render :nothing => true
    end
  end

  def add_user_access_list
    @user = current_user
    content = current_user.user_preference.contact_me ? "Block" : "Allow"
    render :json => { :response => render_to_string(:partial => "user_access_list", :object => UserAccessList.new, :locals => { :status => content }) }
  end

  def delete_skill
    @skill = Skill.find(params[:id])
    @skill.destroy
   respond_to do |format|
    format.html { redirect_to account_url }
    format.js  { render :nothing => true }
  end
  end

  def delete_phone_number
    @phone_number = PhoneNumber.find(params[:id])
    @phone_number.destroy
    redirect_to contact_info_path
  end

  def delete_attachment
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    redirect_to account_path
  end

  def delete_allow_block
    @access_user = UserAccessList.find(params[:id])
    @access_user.destroy
    redirect_to account_path
  end

  def download_file
    @file = Attachment.find(params[:id])
    send_file "public/system/avatars/#{@file.id}/original/#{@file.avatar_file_name}"
  end

  def address_new
    @address = current_user.addresses.build
    render :json => { :data => render_to_string(:partial => "add_address") }
  end

  def address_create
    @address = current_user.addresses.build(params[:address])
    if @address.save
      render :json => { :data => render_to_string(:partial => "show_address", :locals => { :address => @address }), :success => false }
    else
      render :json => { :data => render_to_string(:partial => "add_address"), :success => false }
    end
  end

  def edit_address
    @address = @user.addresses.find(params[:address_id])
    json = { :response => render_to_string(:partial => "edit_address", :locals => {:address_id => @address.id}) }
    render :json => json
  end

  def update_address
    @address = @user.addresses.find(params[:address_id])
    if @address.update_attributes(params[:address])
      json = { :response => render_to_string(:partial => "show_address") }
      render :json => json
    end
  end

  def delete_address
    @address = @user.addresses.find(params[:address_id])
    @address.destroy
    redirect_to contact_info_path
  end


  protected

  def fetch
    @user = current_user
  end

end
