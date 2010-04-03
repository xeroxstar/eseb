require File.dirname(__FILE__) + '/../../spec_helper'
include AuthenticatedTestHelper
include MockTestHelpers
describe ShopAdmin::ShopCategoriesController do
  describe 'require shop owner' do
    before(:each) do
      @user = create_activated_shopowner({:name=>'robdoan'})
      @shop = Shop.make(:owner=>@user)
      @shop_category = ShopCategory.make(:shop=>@shop)
      logout_keeping_session!
    end
  end
  # futher : redirect to no permission page
  describe 'not be shop owner then redirect to home page' do
    before(:each) do
      @user = create_activated_user({:name=>'robdoan'})
      @flash_warning = "You don't have shop"
      login_as(@user)
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
end
