require File.dirname(__FILE__) + '/../spec_helper'
include AuthenticatedTestHelper
include MockTestHelpers
describe ShopsController do
  describe 'route genration' do
    it "should route shops's 'show' action correctly" do
      {:get=>'/shops/shortname'}.should route_to(:controller=>'shops',:action=>'show',:id=>'shortname')
    end

    it "path /myshop should route to shops controller and show action" do
      {:get=>'/myshop'}.should route_to(:controller=>'shops',:action=>'myshop')
    end

    it "should route shops's 'new' action correctly" do
      {:get=>'/shops/new'}.should route_to(:controller=>'shops',:action=>'new')
    end

    it "should route shops's 'edit' action correctly"  do
      {:get=>'/shops/1/edit'}.should route_to(:controller=>'shops',:action=>'edit',:id=>'1')
    end

    it "should route shops's 'create' action correctly" do
      {:post=>'/shops'}.should route_to(:controller=>'shops',:action=>'create')
    end

    it "should route shops's 'update' action correctly" do
      {:put=>'/shops/1'}.should route_to(:controller=>'shops',:action=>'update',:id=>'1')
    end

    it "should route shops's 'deactive' action correctly" do
      {:put=>'/shops/1/deactive'}.should route_to(:controller=>'shops',:action=>'deactive',:id=>'1')
    end

    it "should route shops's 'reactive' action correctly" do
      {:put=>'/shops/1/reactive'}.should route_to(:controller=>'shops',:action=>'reactive',:id=>'1')
    end

    it "should not route to destroy action" do
      {:delete=>'/shops/1'}.should_not be_routable
    end
  end
  describe 'actions' do
    fixtures :users, :shops
    describe 'require login with' do
      before(:each) do
        logout_keeping_session!
        @shop_params = {:name=>'Quynh Khanh',:shortname=>'quynhkhanh'}
      end

      it 'myshop' do
        get :myshop
        response.should redirect_to(new_session_url)
      end

      it 'new shop' do
        get :new
        response.should redirect_to(new_session_url)
      end

      it 'edit' do
        get :edit,:id=>1
        response.should redirect_to(new_session_url)
      end

      it 'create shop' do
        post :create,:shop=>@shop_params
        response.should redirect_to(new_session_url)
      end

      it 'update shop' do
        put :update,:id=>1,:shop=>@shop_params
        response.should redirect_to(new_session_url)
      end

      it 'deactive shop' do
        put :deactive, :id=>1
        response.should redirect_to(new_session_url)
      end

      it 'reactive shop' do
        put :reactive, :id=>1
        response.should redirect_to(new_session_url)
      end

    end
    describe 'show action' do
      before(:each) do
        @shop = mock_shop
      end
      it 'should redirect to home page when can not find shops' do
        Shop.stub!(:find_by_shortname).with('shortname').and_return(nil)
        get :show, :id=>'shortname'
        response.should redirect_to(home_url)
        assigns[:shop].should be_nil
        flash[:warning].should_not be_nil
      end

      it 'should display shop name' do
        Shop.stub!(:find_by_shortname).with('shortname').and_return(@shop)
        get :show, :id=>'shortname'
        response.should render_template('shops/show.html')
        assigns[:shop].should ==@shop
      end
    end

    describe 'create action' do
      before(:each) do
        @user = mock_user
        login_as(@user)
        controller.stub!(:current_user).and_return(@user)
        @shop_valid_data = {:name=>'Quynh Khanh',:shortname=>'quynhkhanh'}
        @shop = mock_shop
      end
      describe 'user have enough personal infomation' do
        before(:each) do
          @user.stub!(:full_personal_infos?).and_return(true)
          Shop.should_receive(:new).and_return(@shop.as_new_record)
        end

        it 'should go to my shop if post valid shop data' do
          @shop.should_receive(:save).and_return(true)
          post :create , :shop=>@shop_valid_data
          response.should redirect_to(my_shop_url)
        end

        it 'should go to render to shops/new template if post invalid shop data' do
          @shop_invalid_data = @shop_valid_data.merge(:shortname=>nil)
          @shop.should_receive(:save).and_return(false)
          post :create , :shop=>@shop_invalid_data
          response.should render_template('shops/new.html')
        end
      end

      describe 'user do not have enough personal infomation' do
        before(:each) do
          @user.stub!(:full_personal_infos?).and_return(false)
        end
        it 'should redirect to edit account page' do
          post :create, :shop=>@shop_valid_data
          response.should redirect_to(edit_user_url(@user))
          flash[:warning].should_not be_nil
        end
      end
    end
  end
end


