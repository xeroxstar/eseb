class ShopsController < ApplicationController
  before_filter :login_required, :except=>[:show]

  def new
  end

  def show
    @shop = Shop.find_by_shortname(params[:id])
    unless @shop
      flash[:notice] = 'Shop can not found'
      redirect_to home_url
    end
  end
end