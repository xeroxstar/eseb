class ProductsController < ApplicationController
  before_filter :login_required, :except =>[:index,:show]

  def index
    @products = Product.avaiable
  end

  def new
    @product = current_user.products.new
  end

  def create
    @product = current_user.products.new(params[:product])
    if @product.save
      redirect_to products_path
    else
      render :new
    end
  end
end
