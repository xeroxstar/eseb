# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include AuthenticatedSystem
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  helper_method :current_user

  #   def current_shopowner
  #     @current_shopowner ||=current_user.becomes(ShopOwner) unless current_user.nil? || !current_user.full_personal_infos?
  #   end

#  def full_personal_info_required
#    unless current_user.full_personal_infos?
#      flash[:warning] = 'you are not a shopowner'
#      redirect_to '/'
#    end
#  end

  protected
  def owner_of_shop
    @shop = current_user.shop
    unless @shop
      flash[:warning] = "You don't have shop"
      redirect_to new_shop_admin_shop_path
    end
  end
end

#class ShopAdmin::ApplicationController < ApplicationController
#  before_filter :owner_of_shop
#end
