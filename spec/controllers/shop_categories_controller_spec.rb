require 'spec_helper'

describe ShopCategoriesController do

  def mock_shop_category(stubs={})
    @mock_shop_category ||= mock_model(ShopCategory, stubs)
  end

  describe "GET index" do
    it "assigns all shop_categories as @shop_categories" do
      ShopCategory.stub!(:find).with(:all).and_return([mock_shop_category])
      get :index
      assigns[:shop_categories].should == [mock_shop_category]
    end
  end

  describe "GET show" do
    it "assigns the requested shop_category as @shop_category" do
      ShopCategory.stub!(:find).with("37").and_return(mock_shop_category)
      get :show, :id => "37"
      assigns[:shop_category].should equal(mock_shop_category)
    end
  end

  describe "GET new" do
    it "assigns a new shop_category as @shop_category" do
      ShopCategory.stub!(:new).and_return(mock_shop_category)
      get :new
      assigns[:shop_category].should equal(mock_shop_category)
    end
  end

  describe "GET edit" do
    it "assigns the requested shop_category as @shop_category" do
      ShopCategory.stub!(:find).with("37").and_return(mock_shop_category)
      get :edit, :id => "37"
      assigns[:shop_category].should equal(mock_shop_category)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created shop_category as @shop_category" do
        ShopCategory.stub!(:new).with({'these' => 'params'}).and_return(mock_shop_category(:save => true))
        post :create, :shop_category => {:these => 'params'}
        assigns[:shop_category].should equal(mock_shop_category)
      end

      it "redirects to the created shop_category" do
        ShopCategory.stub!(:new).and_return(mock_shop_category(:save => true))
        post :create, :shop_category => {}
        response.should redirect_to(shop_category_url(mock_shop_category))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved shop_category as @shop_category" do
        ShopCategory.stub!(:new).with({'these' => 'params'}).and_return(mock_shop_category(:save => false))
        post :create, :shop_category => {:these => 'params'}
        assigns[:shop_category].should equal(mock_shop_category)
      end

      it "re-renders the 'new' template" do
        ShopCategory.stub!(:new).and_return(mock_shop_category(:save => false))
        post :create, :shop_category => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested shop_category" do
        ShopCategory.should_receive(:find).with("37").and_return(mock_shop_category)
        mock_shop_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :shop_category => {:these => 'params'}
      end

      it "assigns the requested shop_category as @shop_category" do
        ShopCategory.stub!(:find).and_return(mock_shop_category(:update_attributes => true))
        put :update, :id => "1"
        assigns[:shop_category].should equal(mock_shop_category)
      end

      it "redirects to the shop_category" do
        ShopCategory.stub!(:find).and_return(mock_shop_category(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(shop_category_url(mock_shop_category))
      end
    end

    describe "with invalid params" do
      it "updates the requested shop_category" do
        ShopCategory.should_receive(:find).with("37").and_return(mock_shop_category)
        mock_shop_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :shop_category => {:these => 'params'}
      end

      it "assigns the shop_category as @shop_category" do
        ShopCategory.stub!(:find).and_return(mock_shop_category(:update_attributes => false))
        put :update, :id => "1"
        assigns[:shop_category].should equal(mock_shop_category)
      end

      it "re-renders the 'edit' template" do
        ShopCategory.stub!(:find).and_return(mock_shop_category(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested shop_category" do
      ShopCategory.should_receive(:find).with("37").and_return(mock_shop_category)
      mock_shop_category.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the shop_categories list" do
      ShopCategory.stub!(:find).and_return(mock_shop_category(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(shop_categories_url)
    end
  end

end
