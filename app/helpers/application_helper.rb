# Methods added to this helper will be available to all templates in the application.
require 'recaptcha'

module ApplicationHelper
  include ReCaptcha::ViewHelper


  def user_index
    return User.find(:all, :conditions => ["users.id != ?",  current_user.id]) 
  end

  def collection_for_users
    result = User.all.map { |i| [i.name, i.id] }
    result << ["Other", -1]
  end

 

  def address_type_options
    add = { "Billing Address" => "billing_address", "Mailing Address" => "mailing_address"}
    add.merge!("Primary Address" => "primary_address") if current_user.addresses.map(&:address_type).include?("primary_address").eql?(false)
    return add
  end


end
