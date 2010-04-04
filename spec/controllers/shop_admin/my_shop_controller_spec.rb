# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ShopAdmin::MyShopController do
  before(:each) do
    @shop_owner = create_activated_shopowner()
  end
  describe "require shop owner" do
    before(:each) do
      login_as(@shop_owner)
      @valid_shop = {:name=>Sham.name, :shortname=>Sham.shortname,:category_id=>1}
    end
    it 'new shop should redirect to my shop if user already have shop' do
      Shop.make(:owner=>@shop_owner)
      get :new
      response.should redirect_to('/myshop')
    end

    it 'create should redirect to myshop' do
      lambda {
        post :create, :shop=>@valid_shop
        response.should redirect_to('/myshop')
      }.should change(Shop,:count).by(1)
    end

    it 'create should render template new if creating is unsuccess' do
      lambda {
        post :create, :shop=>@valid_shop.merge(:category_id=>nil)
        response.should render_template('shop_admin/my_shop/new.html.erb')
      }.should change(Shop,:count).by(0)
    end

    it 'new shop should render new template' do
      get :new
      response.should render_template('shop_admin/my_shop/new.html.erb')
    end

    describe 'owner of shop' do
      it 'edit require owner of shop' do
        get :edit
        response.should redirect_to('/')
      end
      it 'update require owner of shop' do
        put :update
        response.should redirect_to('/')
      end

      it 'deactive require owner of shop' do
        put :deactive
        response.should redirect_to('/')
      end

      it 'reactive require owner of shop' do
        put :reactive
        response.should redirect_to('/')
      end
    end

    describe 'user had shop' do
      before(:each) do
        Shop.make(:owner=>@shop_owner)
      end
      it 'edit should render edit template' do
        get :edit
        response.should render_template('shop_admin/my_shop/edit.html.erb')
      end

      it 'update should redirect to myshop' do
        put :update, :shop=>{:name=>'updatename'}
        assigns[:shop].name.should =='updatename'
        response.should redirect_to('/myshop')
      end

      it 'update should render template edit if updating is unsuccess' do
        put :update, :shop=>{:name=>'updatename',:category_id=>nil}
        response.should render_template('shop_admin/my_shop/edit.html.erb')
      end

      it 'should be able to deactive' do
        put :deactive
        @shop_owner.shop.should be_unactive
      end

      it 'should be able to reactive' do
        put :reactive
        @shop_owner.shop.should be_active
      end
    end
  end

end

