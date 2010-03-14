class ShopCategoriesController < ApplicationController
  before_filter :owner_of_shop
  # GET /shop_categories
  # GET /shop_categories.xml
  def index
    @shop_categories = ShopCategory.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shop_categories }
    end
  end

  # GET /shop_categories/1
  # GET /shop_categories/1.xml
  def show
    @shop_category = ShopCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @shop_category }
    end
  end

  # GET /shop_categories/new
  # GET /shop_categories/new.xml
  def new
    @shop_category = @shop.shop_categories.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shop_category }
    end
  end

  # GET /shop_categories/1/edit
  def edit
    @shop_category = @shop.shop_category.find(params[:id])
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
    @shop_category = ShopCategory.find(params[:id])

    respond_to do |format|
      if @shop_category.update_attributes(params[:shop_category])
        flash[:notice] = 'ShopCategory was successfully updated.'
        format.html { redirect_to(@shop_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shop_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @shop_category = ShopCategory.find(params[:id])
    @shop_category.destroy

    respond_to do |format|
      format.html { redirect_to('/myshop') }
      format.xml  { head :ok }
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
      flash[:notice] = "you don't have permission to access this page"
      redirect_to '/'
    end
  end
end
