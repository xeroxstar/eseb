require 'spec_helper'

describe "/shop_categories/new.html.erb" do
  include ShopCategoriesHelper

  before(:each) do
    assigns[:shop_category] = stub_model(ShopCategory,
      :new_record? => true
    )
  end

  it "renders new shop_category form" do
    render

    response.should have_tag("form[action=?][method=post]", shop_categories_path) do
    end
  end
end
