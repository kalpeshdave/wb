class UserAddressesController < ApplicationController
  before_filter :require_user

  def edit
    @address = current_user.addresses.find(params[:id])
    render :json => { :data => render_to_string(:partial => "edit") }
  end

  def update
    @address = current_user.addresses.find(params[:id])
    if @address.update_attributes(params[:address])
      render :json => { :data => render_to_string(:partial => "users/show_address", :locals => { :address => @address }), :success => true, :address_id => @address.id }
    end
  end
end
