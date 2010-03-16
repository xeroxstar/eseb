require 'spec_helper'

describe ShopCategory do
  before(:each) do
    @shop = shops(:crazy_love)
    @subcategory = categories(:baby_sub1)
    @valid_attributes = {
      :name=>'shop category',
      :subcategory=>@subcategory,
      :shop=>@shop
    }
  end

  it "should create a new instance given valid attributes" do
    ShopCategory.create!(@valid_attributes)
  end
  it 'require name' do
     @shop_category = ShopCategory.create(@valid_attributes.merge(:name=>''))
     @shop_category.errors.on(:name).should_not be_nil
  end

  describe 'association' do
    it 'belongs to shop' do
      @shop_category = ShopCategory.create!(@valid_attributes)
      @shop_category.shop.should be_kind_of(Shop)
    end
    it 'belongs to subcategory' do
      @shop_category = ShopCategory.create!(@valid_attributes)
      @shop_category.subcategory.should be_kind_of(Category)
    end
  end
end
