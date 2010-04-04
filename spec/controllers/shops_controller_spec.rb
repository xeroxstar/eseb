require File.dirname(__FILE__) + '/../spec_helper'
#include AuthenticatedTestHelper
include MockTestHelpers
describe ShopsController do
  describe 'actions' do
    before(:each) do
      @subcategory1 = Category.make(:subcategory)
      @subcategory2 = Category.make(:subcategory)
      @shop = Shop.make(:shortname=>'quydoan')
      3.times {Product.make(:subcategory=>@subcategory1,:shop=>@shop)}
      3.times {Product.make(:subcategory=>@subcategory2,:shop=>@shop)}
    end
    #    describe 'require login with' do
    #      before(:each) do
    #        logout_keeping_session!
    #        @shop_params = {:name=>'Quynh Khanh',:shortname=>'quynhkhanh'}
    #      end
    #      {:get=>[:new,:edit,:myshop],:put=>[:update],:post=>[:create]}.each_pair do |key,actions|
    #        actions.each do |action|
    #          it "method: #{key} - action: #{action} require you are shopowner" do
    #            eval("#{key} action,:id=>1,:shop=>@shop_params")
    #            response.should redirect_to(new_session_url)
    #          end
    #        end
    #      end
    #    end
    #    describe 'require full personal info' do
    #      before(:each) do
    #        @user = users(:quentin)
    #        login_as(@user)
    #        @user.should_not be_full_personal_infos
    #      end
    #      {:get=>[:new,:edit,:myshop],:put=>[:update],:post=>[:create]}.each_pair do |key,actions|
    #        actions.each do |action|
    #          it "method: #{key} - action: #{action} require you are shopowner" do
    #            eval("#{key} action,:id=>1")
    #            flash[:warning].should_not be_nil
    #            response.should redirect_to('/')
    #          end
    #        end
    #      end
    #    end
    it 'index' do
      get :index
      assigns[:shops].should be_a(Array)
      response.should render_template('shops/index.html.erb')
    end

    it 'show page should redirect to home page when can not find shops' do
      get :show, :id=>'shortname'
      response.should redirect_to(home_url)
      assigns[:shop].should be_nil
      flash[:warning].should_not be_nil
    end

    it 'show shop page should display products' do
      get :show, :id=>'quydoan'
      response.should render_template('shops/show.html')
      assigns[:shop].should ==@shop
      assigns[:products].should be_a(Array)
    end

    it 'show shop page should display products with filter shop category' do
      get :show, :id=>'quydoan' , :shop_category_id=>@subcategory1.id
      assigns[:shop].should ==@shop
      assigns[:products].each do |p|
        p.subcategory.should ==@subcategory1
      end
      response.should render_template('shops/show.html')
    end

    #      it 'my shop' do
    #        @user = create_activated_shopowner(:shop=>@shop)
    #        login_as(@user)
    #        get :myshop
    #        controller.current_user.shop.should_not be_nil
    #        controller.current_user.should be_kind_of(ShopOwner)
    #        response.should render_template('shops/myshop.html')
    #      end

    #      it "redirect to create shop when I go to my shop and havent create shop" do
    #        @user = users(:no_shop_user)
    #        login_as(@user)
    #        get :myshop
    #        response.should redirect_to(new_shop_url)
    #      end
  end

  #    describe 'create/update shop' do
  #      before(:each) do
  #        @shop_valid_data = {:name=>'Quynh Khanh',:shortname=>'quynhkhanh'}
  #      end
  #
  #      describe 'user have enough personal infomation' do
  #        before(:each) do
  #          @user = users(:no_shop_user)
  #          login_as(@user)
  #        end
  #
  #        it 'new action' do
  #          get :new
  #          assigns[:shop].should be_kind_of(Shop)
  #          response.should render_template('shops/new.html')
  #        end
  #
  #        it 'edit action' do
  #          create_shop(@user,@shop_valid_data)
  #          get :edit, :id=>@shop.id
  #          assigns[:shop].should ==@shop
  #          response.should render_template('shops/edit.html')
  #        end
  #
  #        it 'edit action raise exception' do
  #          lambda do
  #            get :edit, :id=>1
  #            response.should be_use_rails_error_handling
  #          end.should raise_error
  #        end
  #
  #        it 'should go to my shop if update valid shop data' do
  #          create_shop(@user,@shop_valid_data)
  #          lambda do
  #            put :update , :id=>@shop.id,  :shop=>@shop_valid_data
  #            assigns[:shop].should be_kind_of(Shop)
  #            response.should redirect_to(my_shop_url)
  #          end.should_not change(Shop,:count)
  #        end
  #
  #        it 'should render shops/edit if upate invalid shop data' do
  #          create_shop(@user,@shop_valid_data)
  #          lambda do
  #            put :update , :id=>@shop.id,:shop=>@shop_valid_data.merge(:shortname=>nil)
  #            assigns[:shop].errors.on(:shortname).should_not be_nil
  #            response.should render_template('shops/edit.html')
  #          end.should_not change(Shop,:count)
  #        end
  #
  #        it 'should render raise error when I try to edit shop of another user' do
  #          @user2 = users(:shopowner)
  #          create_shop(@user2,@shop_valid_data)
  #          lambda do
  #            put :update ,:id=>@shop.id, :shop=>@shop_valid_data.merge(:shortname=>nil)
  #          end.should raise_error
  #        end
  #
  #        it 'should go to my shop if post valid shop data' do
  #          lambda do
  #            post :create , :shop=>@shop_valid_data
  #            assigns[:shop].should be_kind_of(Shop)
  #            response.should redirect_to(my_shop_url)
  #          end.should change(Shop,:count).by(1)
  #        end
  #
  #        it 'should render to shops/new template if post invalid shop data' do
  #          @shop_invalid_data = @shop_valid_data.merge(:shortname=>nil)
  #          lambda do
  #            post :create , :shop=>@shop_invalid_data
  #            assigns[:shop].errors.on(:shortname).should_not be_nil
  #            response.should render_template('shops/new.html')
  #          end.should_not change(Shop,:count)
  #        end
  #      end
  #    end
  #    it 'deactive' do
  #      @user = users(:robdoan)
  #      login_as(@user)
  #      put :deactive
  #      @user.shop.should be_unactive
  #    end
  #    it  'reactive' do
  #      @user = users(:robdoan)
  #      login_as(@user)
  #      @user.shop.deactivate
  #      @user.shop.should be_unactive
  #      put :reactive
  #      assigns[:shop].should be_active
  #    end
  def create_shop(user,data)
    @shop = user.create_shop(data)
  end
end



