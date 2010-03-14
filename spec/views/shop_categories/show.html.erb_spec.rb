require 'spec_helper'

describe "/shop_categories/show.html.erb" do
  include ShopCategoriesHelper
  before(:each) do
    assigns[:shop_category] = @shop_category = stub_model(ShopCategory)
  end

  it "renders attributes in <p>" do
    render
  end
end
