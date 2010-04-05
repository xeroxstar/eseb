class ProductsController < ApplicationController
  before_filter :login_required, :except =>[:index,:show]
  layout false, :only=>[:new]
  def index
    @products = Product.avaiable
  end

  def show
    @product = Product.avaiable.find(params[:id])
  end

  def new
    @product = current_user.products.new
  end

  def create
    @product = current_user.products.new(params[:product])
    if @product.save
      render :action=>'update_product'
    else
      render :new
    end
  end
end
