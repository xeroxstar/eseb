class ShopsController < ApplicationController
  before_filter :login_required, :except=>[:show]

  def new
  end

  def show
    @shop = Shop.find_by_shortname(params[:id])
    unless @shop
      flash[:warning] = 'Shop can not found'
      redirect_to home_url
    end
  end

  def create
    if current_user.full_personal_infos?
      @shop = Shop.new(params[:shop])
      if @shop.save
        flash[:notice] = 'success'
        redirect_to(my_shop_path)
      else
        render :action=>'new'
      end
    else
      flash[:warning] = "you haven't put enough infomation."
      redirect_to(edit_user_path(current_user))
    end
  end
end