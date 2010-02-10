require File.dirname(__FILE__) + '/../spec_helper'
include AuthenticatedTestHelper
include MockTestHelpers
describe ShopsController do
  fixtures :users
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
      {:get=>[:new,:edit,:myshop],:put=>[:update],:post=>[:create]}.each_pair do |key,actions|
        actions.each do |action|
          it "method: #{key} - action: #{action} require you are shopowner" do
            eval("#{key} action,:id=>1,:shop=>@shop_params")
            response.should redirect_to(new_session_url)
          end
        end
      end
    end
    describe 'require shopowner' do
      before(:each) do
        @user = users(:quentin)
        login_as(@user)
        @user.should_not be_full_personal_infos
      end
      {:get=>[:new,:edit,:myshop],:put=>[:update],:post=>[:create]}.each_pair do |key,actions|
        actions.each do |action|
          it "method: #{key} - action: #{action} require you are shopowner" do
            eval("#{key} action,:id=>1")
            flash[:warning].should_not be_nil
            response.should redirect_to('/')
          end
        end
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

      it 'my shop' do
        @user = users(:shopowner)
        create_shop(@user,@shop_valid_data)
        login_as(@user)
        get :myshop
        controller.current_shopowner.shop.should_not be_nil
        response.should render_template('shops/myshop.html')
      end

      it 'redirect to create shop when I go to my shop and havent create shop ' do
        @user = users(:shopowner)
        login_as(@user)
        get :myshop
        response.should redirect_to(new_shop_url)
      end
    end

    describe 'create/update shop' do
      before(:each) do
        @shop_valid_data = {:name=>'Quynh Khanh',:shortname=>'quynhkhanh'}
      end

      describe 'user have enough personal infomation' do
        before(:each) do
          @user = users(:shopowner)
          login_as(@user)
        end

        it 'new action' do
          get :new
          assigns[:shop].should be_kind_of(Shop)
          response.should render_template('shops/new.html')
        end

        it 'edit action' do
          create_shop(@user,@shop_valid_data)
          get :edit, :id=>@shop.id
          assigns[:shop].should ==@shop
          response.should render_template('shops/edit.html')
        end

        it 'edit action raise exception' do
          lambda do
            get :edit, :id=>1
            response.should be_use_rails_error_handling
          end.should raise_error
        end



        it 'should go to my shop if update valid shop data' do
          create_shop(@user,@shop_valid_data)
          lambda do
            put :update , :id=>@shop.id,  :shop=>@shop_valid_data
            assigns[:shop].should be_kind_of(Shop)
            response.should redirect_to(my_shop_url)
          end.should_not change(Shop,:count)
        end

        it 'should render shops/edit if upate invalid shop data' do
          create_shop(@user,@shop_valid_data)
          lambda do
            put :update , :id=>@shop.id,:shop=>@shop_valid_data.merge(:shortname=>nil)
            assigns[:shop].errors.on(:shortname).should_not be_nil
            response.should render_template('shops/edit.html')
          end.should_not change(Shop,:count)
        end

        it 'should render raise error when I try to edit shop of another user' do
          @user2 = users(:shopowner_quy)
          create_shop(@user2,@shop_valid_data)
          lambda do
            put :update ,:id=>@shop.id, :shop=>@shop_valid_data.merge(:shortname=>nil)
          end.should raise_error
        end

        it 'should go to my shop if post valid shop data' do
          lambda do
            post :create , :shop=>@shop_valid_data
            assigns[:shop].should be_kind_of(Shop)
            response.should redirect_to(my_shop_url)
          end.should change(Shop,:count).by(1)
        end

        it 'should render to shops/new template if post invalid shop data' do
          @shop_invalid_data = @shop_valid_data.merge(:shortname=>nil)
          lambda do
            post :create , :shop=>@shop_invalid_data
            assigns[:shop].errors.on(:shortname).should_not be_nil
            response.should render_template('shops/new.html')
          end.should_not change(Shop,:count)
        end
      end
    end
  end
  def create_shop(user,data)
    @shop = user.create_shop(data)
  end
end



