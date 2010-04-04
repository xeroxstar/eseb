# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ShopAdmin::ProductsController do
  before(:each) do
    @user = create_activated_shopowner()
    @valid_product = valid_product
    login_as(@user)
  end
  describe 'require  user must has shop' do
    it 'new product' do
      get :new
      response.should redirect_to('/')
    end
    it 'edit product' do
      get :edit, :id=>1
      response.should redirect_to('/')
    end
    it 'update product' do
      put :update, :id=>1, :product=>@valid_product
      response.should redirect_to('/')
    end
    it 'create product' do
      post :create, :product=>@valid_product
      response.should redirect_to('/')
    end
    it 'destroy product' do
      delete :destroy, :id=>1
      response.should redirect_to('/')
    end
  end
  describe 'action' do
    before(:each)  do
      @shop = Shop.make(:owner=>@user)
      @product = Product.make(:shop=>@shop,:id=>10)
    end
    it 'new product' do
      get :new
      assigns[:product].should_not be_nil
      response.should render_template 'shop_admin/products/new.html.erb'
    end
    it 'edit product' do
      get :edit, :id=>10
      assigns[:product].should == @product
      response.should render_template 'shop_admin/products/edit.html.erb'
    end
    it 'create product' do
      lambda {
        post :create, :product=>@valid_product
        assigns[:product].shop.should == @shop
        response.should redirect_to '/myshop'
      }.should change(Product, :count).by(1)
    end
    it 'create product should be rendered to :new if creating is unsuccess' do
      lambda {
        post :create, :product=>@valid_product.merge(:name=>nil)
        response.should render_template('shop_admin/products/new.html.erb')
      }.should change(Product, :count).by(0)
    end
    it 'update product' do
      lambda {
        put :update, :id=>@product.id, :product=>{:name=>'test product name'}
        assigns[:product].name.should == 'test product name'
      }.should change(Product, :count).by(0)
    end
    it 'update product should be raise error if you are not the owner of product' do
      lambda {
        put :update, :id=>1, :product=>{:name=>'test product name'}
      }.should raise_exception
    end
    it 'update product should be rendered to :edit if creating is unsuccess' do
      put :update, :id=>10, :product=>{:name=>nil}
      response.should render_template('shop_admin/products/edit.html.erb')
    end
    it 'destroy' do
      lambda {
        delete :destroy, :id=>10
        response.should redirect_to('/myshop')
      }.should change(Product, :count).by(-1)
    end
    it 'destroy product should be raise error if you are not the owner of product' do
      lambda {
        delete :destroy, :id=>1
      }.should raise_exception
    end

  end
end

