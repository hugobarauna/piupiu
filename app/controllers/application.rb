# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'a7f43b4a0b07f29c5a5d2a914ceec615'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  layout 'default'
  
  before_filter :find_current_user

  protected
    def find_current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    
    def required_login
      if session[:user_id].nil?
        session[:return_to] = request.request_uri
        flash[:error] = "You need to login to do this."
        redirect_to new_user_session_path 
      end
    end
end
