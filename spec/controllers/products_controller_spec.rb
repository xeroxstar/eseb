require 'spec_helper'
#include AuthenticatedTestHelper
describe ProductsController do
  describe 'require login' do
    before(:each) do
      @user = create_activated_user
      login_as(@user)
      @user.products.make(:id=>1)
      @valid_product= {:name=>Sham.name}
    end
    it 'new product' do
      get :new
      response.should render_template('products/new.html')
    end

    it 'create a product' do
      post :create, :product=>@valid_product
      response.should redirect_to products_path
    end

    it 'create a product should render new if save unsucess' do
      post :create, :product=>@valid_product.merge(:name=>nil)
      assigns[:product].errors.should_not be_empty
      response.should render_template('products/new.html')
    end

  end

  describe 'no require login' do
    before(:each) do
      logout_keeping_session!
      @product = Product.make(:id=>1)
    end
    it 'product index page' do
      get :index
      assigns[:products].should_not be_nil
      response.should render_template('products/index.html')
    end
    it 'product detail' do
      controller.should_receive(:render).with(:layout=>false)
      get :show, :id=>1
      assigns[:product].should ==@product
    end
  end

end
