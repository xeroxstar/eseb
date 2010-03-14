require 'spec_helper'

describe "/shop_categories/edit.html.erb" do
  include ShopCategoriesHelper

  before(:each) do
    assigns[:shop_category] = @shop_category = stub_model(ShopCategory,
      :new_record? => false
    )
  end

  it "renders the edit shop_category form" do
    render

    response.should have_tag("form[action=#{shop_category_path(@shop_category)}][method=post]") do
    end
  end
end
