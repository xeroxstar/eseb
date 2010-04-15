class ShopsController < ApplicationController
  before_filter :find_shop , :except=>[:index]
  def index
    @shops = Shop.actived.paginate :per_page=>10, :page=>params[:page]
  end

  def show
    @products = @shop.products
    if params[:shop_category_id]
      @products = @products.in_shop_category(params[:shop_category_id])
    end
  end

  def near_by_me
    @shops = current_user.shops_near_me(10)
    @map = GMap.new("map_div")
    @map.control_init(:small_map => true,:map_type => true)
    points = [current_user.lat,current_user.lng]
#    @map.center_zoom_init([current_user.lat,current_user.lng],1)
    @map.overlay_init(GMarker.new([current_user.lat,current_user.lng],:title =>"You"))
    for shop in @shops do
      @map.overlay_init(GMarker.new([shop.lat,shop.lng],:icon=>:cafeIcon,:title =>"#{shop.id}"))
      points << [shop.lat,shop.lng]
    end
    unless points.blank?
      @map.center_zoom_on_points_init(points)
    end
    render :action=>'map', :layout=>false
  end

  def map
    location = @shop.addresses.first
    @map = GMap.new("map_div")
    @map.control_init(:small_map => true,:map_type => true)
    @map.interface_init(:double_click_zoom=>true)
    @map.center_zoom_init([location.lat,location.lng],16)
    @map.overlay_init(GMarker.new([location.lat,location.lng],:icon=>:cafeIcon,:title =>"#{@shop.name}",
        :info_window=>'indida'))
    render :layout=>false
  end

  protected
  def find_shop
    @shop = Shop.actived.find_by_shortname(params[:id])
    unless @shop
      flash[:warning] = 'Shop can not found'
      redirect_to home_url
    end
  end
end