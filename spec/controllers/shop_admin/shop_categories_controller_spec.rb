require File.dirname(__FILE__) + '/../../spec_helper'
include AuthenticatedTestHelper
include MockTestHelpers
describe ShopAdmin::ShopCategoriesController do

  #Delete this example and add some real ones
  describe 'route genration' do
    it "should route shop_categories's 'new' action correctly" do
      {:get=>'/shop_admin/shop_categories/new'}.should route_to(:controller=>'shop_admin/shop_categories',:action=>'new')
    end

    it "should route shop_categories's 'edit' action correctly"  do
      {:get=>'/shop_admin/shop_categories/1/edit'}.should route_to(:controller=>'shop_admin/shop_categories',:action=>'edit',:id=>'1')
    end

    it "should route shop_categories's 'create' action correctly" do
      {:post=>'/shop_admin/shop_categories'}.should route_to(:controller=>'shop_admin/shop_categories',:action=>'create')
    end

    it "should route shop_categories's 'update' action correctly" do
      {:put=>'/shop_admin/shop_categories/1'}.should route_to(:controller=>'shop_admin/shop_categories',:action=>'update',:id=>'1')
    end
    it "should not route to destroy action" do
      {:delete=>'/shop_admin/shop_categories/1'}.should route_to(:controller=>'shop_admin/shop_categories',:action=>'destroy',:id=>'1')
    end
  end

  describe 'require shop owner' do
    before(:each) do
      @user = users(:robdoan)
      @shop_category = shop_categories(:one)
      logout_keeping_session!
    end
    # futher : redirect to no permission page
    describe 'not be shop owner then redirect to home page' do
      before(:each) do
        login_as(@user)
        @shop_category_params = {:name=>'shop category',:subcategory_id=>1}
      end
      it 'new shop_category' do
        get :new
        be_redirect_to_home_page
      end
      it 'edit shop_category' do
        get :edit,  :id=>@shop_category.id
        be_redirect_to_home_page
      end
      it 'update shop_category' do
        put :update,  :shop_category=>@shop_category_params,:id=>@shop_category.id
        be_redirect_to_home_page
      end
      it 'create shop_category' do
        post :create, :shop_category=>@shop_category_params
        be_redirect_to_home_page
      end
      it 'edit shop_category' do
        delete :destroy, :id=>@shop_category.id
        be_redirect_to_home_page
      end
    end
  end

end
