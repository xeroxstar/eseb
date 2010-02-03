# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
#  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include AuthenticatedSystem
  # Scrub sensitive parameters from your log
   filter_parameter_logging :password
   helper_method :current_user

   def current_shopowner
     current_user.becomes(ShopOwner) unless current_user.nil? || !current_user.full_personal_infos?
   end

   def require_shopowner
     unless current_shopowner
       redirect_to '/'
     end
   end



end
