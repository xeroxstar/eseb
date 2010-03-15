require File.dirname(__FILE__) + '/../spec_helper'
include AuthenticatedTestHelper
include MockTestHelpers

describe ShopCategoriesController do

  describe 'route genration' do
    it "should route shop_categories's 'new' action correctly" do
      {:get=>'/shops/1/shop_categories/new'}.should route_to(:controller=>'shop_categories',:action=>'new',:shop_id=>'1')
    end

    it "should route shop_categories's 'edit' action correctly"  do
      {:get=>'/shops/1/shop_categories/1/edit'}.should route_to(:controller=>'shop_categories',:action=>'edit',:id=>'1',:shop_id=>'1')
    end

    it "should route shop_categories's 'create' action correctly" do
      {:post=>'/shops/1/shop_categories'}.should route_to(:controller=>'shop_categories',:action=>'create',:shop_id=>'1')
    end

    it "should route shop_categories's 'update' action correctly" do
      {:put=>'/shops/1/shop_categories/1'}.should route_to(:controller=>'shop_categories',:action=>'update',:id=>'1',:shop_id=>'1')
    end
    it "should not route to destroy action" do
      {:delete=>'/shops/1/shop_categories/1'}.should route_to(:controller=>'shop_categories',:action=>'destroy',:id=>'1',:shop_id=>'1')
    end
  end

  describe 'require shop owner' do
    before(:each) do
      @user = users(:robdoan)
      @owner = users(:shopowner)
      @shop = shops(:crazy_love)
      @shop_category= shop_categories(:one)
      logout_keeping_session!
    end
    # futher : redirect to no permission page
    describe 'not be shop owner then redirect to home page' do
      before(:each) do
        login_as(@user)
        @shop_category_params = {:name=>'shop category',:subcategory_id=>1}
      end
      it 'new shop_category' do
        get :new, :shop_id=>@shop.id
        be_redirect_to_home_page
      end
      it 'edit shop_category' do
        get :edit, :shop_id=>@shop.id, :id=>@shop_category.id
        be_redirect_to_home_page
      end
      it 'update shop_category' do
        put :update, :shop_id=>@shop.id, :shop_category=>@shop_category_params,:id=>@shop_category.id
        be_redirect_to_home_page
      end
      it 'create shop_category' do
        post :create, :shop_id=>@shop.id, :shop_category=>@shop_category_params
        be_redirect_to_home_page
      end
      it 'edit shop_category' do
        delete :destroy, :shop_id=>@shop.id, :id=>@shop_category.id
        be_redirect_to_home_page
      end
    end
  end
end
