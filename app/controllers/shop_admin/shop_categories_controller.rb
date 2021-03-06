class ShopAdmin::ShopCategoriesController < ShopAdmin::ApplicationController
  layout false , :only=>[:edit,:new]
  def new
    @shop_category = @shop.shop_categories.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shop_category }
    end
  end

  def edit
    @shop_category = @shop.shop_categories.find(params[:id])
  end

  # POST /shop_categories
  # POST /shop_categories.xml
  def create
    @shop_category = @shop.shop_categories.new(params[:shop_category])
    respond_to do |format|
      if @shop_category.save
        flash[:notice] = 'ShopCategory was successfully created.'
        format.html { redirect_to '/myshop' }
        format.xml  { render :xml => @shop_category, :status => :created, :location => @shop_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shop_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shop_categories/1
  # PUT /shop_categories/1.xml
  def update
    @shop_category = @shop.shop_categories.find(params[:id])
    respond_to do |format|
      if @shop_category.update_attributes(params[:shop_category])
        flash[:notice] = 'ShopCategory was successfully updated.'
        format.html { redirect_to '/myshop' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shop_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @shop_category = @shop.shop_categories.find(params[:id])
    @shop_category.destroy
    respond_to do |format|
      format.html { redirect_to('/myshop') }
      format.xml  { head :ok }
    end
  end

end
