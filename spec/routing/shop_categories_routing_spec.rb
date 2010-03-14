require 'spec_helper'

describe ShopCategoriesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/shop_categories" }.should route_to(:controller => "shop_categories", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/shop_categories/new" }.should route_to(:controller => "shop_categories", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/shop_categories/1" }.should route_to(:controller => "shop_categories", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/shop_categories/1/edit" }.should route_to(:controller => "shop_categories", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/shop_categories" }.should route_to(:controller => "shop_categories", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/shop_categories/1" }.should route_to(:controller => "shop_categories", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/shop_categories/1" }.should route_to(:controller => "shop_categories", :action => "destroy", :id => "1") 
    end
  end
end
