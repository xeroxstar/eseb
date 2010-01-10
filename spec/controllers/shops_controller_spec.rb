require File.dirname(__FILE__) + '/../spec_helper'
include AuthenticatedTestHelper
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
end
