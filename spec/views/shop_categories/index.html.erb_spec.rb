require 'spec_helper'

describe "/shop_categories/index.html.erb" do
  include ShopCategoriesHelper

  before(:each) do
    assigns[:shop_categories] = [
      stub_model(ShopCategory),
      stub_model(ShopCategory)
    ]
  end

  it "renders a list of shop_categories" do
    render
  end
end
