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

  def full_personal_info_required
    unless current_user.full_personal_infos?
      flash[:warning] = 'you are not a shopowner'
      redirect_to '/'
    end
  end

  protected
  def owner_of_shop
    if params[:shop_id]
      @shop = Shop.find(params[:shop_id])
    else
      @shop = current_user.shop
    end
    if current_user != @shop.owner
      flash[:warning] = "you don't have permission to access this page"
      redirect_to '/'
    end
  end
end

class ShopAdmin::ApplicationController < ApplicationController

end
