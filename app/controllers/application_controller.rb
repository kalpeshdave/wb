# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  include ReCaptcha::AppHelper
  helper_method :current_user_session, :current_user, :can_edit?
  filter_parameter_logging :password, :password_confirmation
  audit Timesheet, Contract


  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
#        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end

    def require_company
      if current_user.company_users.blank?
        store_location
        flash[:notice] = "You must be select company for your profile to access this page"
        redirect_to account_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def forbidden
      render :file => "#{RAILS_ROOT}/public/403.html", :status	=> 403
    end

    def can_edit?(contract)
      
    return true if contract.originator?(current_user)

    case
    when contract
#      contract.creator == current_user and contract.editable?(current_user)
    else
      false
    end
  end
end
