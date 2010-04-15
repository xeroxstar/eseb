class ShopAdmin::ProductsController < ShopAdmin::ApplicationController
  layout false, :only=>[:new,:edit]
  def new
    @product = current_user.products.new
  end

  def edit
    @product = current_user.products.find(params[:id])
  end

  def show
  end

  def create
    @product = current_user.products.new(params[:product])
    @product.add_to_shop=1 # Add this product to shop
    if @product.save
      if facebook_session.user && facebook_session.user.has_permission?('publish_stream')
        ProductPublisher.deliver_publish_create_product(facebook_session.user,@product)
      end
      redirect_to '/myshop'
    else
      render :new
    end
  end

  def update
    @product = current_user.products.find(params[:id])
    if @product.update_attributes(params[:product].merge(:add_to_shop=>1))
      redirect_to '/myshop'
    else
      render :edit
    end
  end

  def destroy
    @product = current_user.products.find(params[:id])
    @product.destroy
    redirect_to '/myshop'
  end
end