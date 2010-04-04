require File.dirname(__FILE__) + '/../../spec_helper'
#include AuthenticatedTestHelper

describe ShopAdmin::ShopCategoriesController do
  before(:each) do
    @valid_shop_category= valid_shop_category
    @user = create_activated_shopowner({:name=>'robdoan'})
    login_as(@user)
  end

  describe 'user must have shop' do
    before(:each) do
      @flash_warning = "You don't have shop"
      @shop_category_params = {:name=>'shop category',:subcategory_id=>1}
    end
    it 'new shop_category' do
      get :new
      be_redirect_to_home_page(@flash_warning)
    end
    it 'edit shop_category' do
      get :edit,  :id=>1
      be_redirect_to_home_page(@flash_warning)
    end
    it 'update shop_category' do
      put :update,  :shop_category=>@shop_category_params,:id=>1
      be_redirect_to_home_page(@flash_warning)
    end
    it 'create shop_category' do
      post :create, :shop_category=>@shop_category_params
      be_redirect_to_home_page(@flash_warning)
    end
    it 'edit shop_category' do
      delete :destroy, :id=>1
      be_redirect_to_home_page(@flash_warning)
    end
  end
  describe 'actions' do
    before(:each) do
      @shop = Shop.make(:owner=>@user)
      @shop_category = ShopCategory.make(:shop=>@shop, :id=>10)
    end
    it 'new shop category' do
      get :new
      assigns[:shop_category].should_not be_nil
      response.should render_template('shop_admin/shop_categories/new.html.erb')
    end
    it 'edit shop category' do
      get :edit, :id=>10
      assigns[:shop_category].should ==@shop_category
      response.should render_template('shop_admin/shop_categories/edit.html.erb')
    end
    it 'create shop category' do
      lambda{
        post :create, :shop_category=>@valid_shop_category
        assigns[:shop_category].shop.should ==@shop
        response.should redirect_to('/myshop')
      }.should change(ShopCategory,:count).by(1)
    end
    it 'creating shop category should rendered :new if invailid data' do
      lambda{
        post :create, :shop_category=>@valid_shop_category.merge(:name=>nil)
        response.should render_template('shop_admin/shop_categories/new.html.erb')
      }.should_not change(ShopCategory,:count)
    end
    it 'update shop category should raise exception if user is not owner of shop category' do
      lambda{
        put :update, :id=>1
      }.should raise_exception
    end
    it 'update shop category' do
      lambda{
        put :update, :id=>10, :shop_category=>{:name=>'update cat name'}
        assigns[:shop_category].name.should =='update cat name'
      }.should_not change(ShopCategory,:count)
    end
    it 'update shop category' do
      put :update, :id=>10, :shop_category=>{:name=>nil}
      response.should render_template('shop_admin/shop_categories/edit.html.erb')
    end
    it 'destroy category' do
      lambda{
        delete :destroy, :id=>10
        response.should redirect_to('/myshop')
      }.should change(ShopCategory,:count).by(-1)
    end
  end
end
