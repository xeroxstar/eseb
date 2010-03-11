require File.dirname(__FILE__) + '/../spec_helper'

describe ShopOwner do
  before(:each) do
    @shop_owner = users(:robdoan)
    @valid_shop_data = {:name=>'quynhkhanh',:shortname=>'quynhkhanh'}
  end
  describe 'validate attributes' do
    it 'lenght of first name and last name should more than 3' do
      @shop_owner.update_attributes(:first_name=>'aa',:last_name=>'cc')
      @shop_owner.errors.on(:first_name).should_not be_nil
      @shop_owner.errors.on(:last_name).should_not be_nil
    end

    describe 'legitimate last and first name' do
      ['a bac','quynh-pham','a.Sen','ten gii'].each do |name|
        it "'#{name}'" do
          @shop_owner.update_attributes(:first_name=>name,:last_name=>name)
          @shop_owner.errors.on(:first_name).should be_nil
          @shop_owner.errors.on(:last_name).should be_nil
        end
      end
    end#END 'legitimate last and first name'

    describe 'illegitimate last and first name' do
      ['a@bac','quynh|pham','a(Sen','ten99+asgii'].each do |name|
        it "'#{name}'" do
          @shop_owner.update_attributes(:first_name=>name,:last_name=>name)
          @shop_owner.errors.on(:first_name).should_not be_nil
          @shop_owner.errors.on(:last_name).should_not be_nil
        end
      end
    end#END 'legitimate last and first name'

    it 'lenght of address should more than 12 characters' do
      @shop_owner.update_attributes(:address=>'exae12aaa')
      @shop_owner.errors.on(:address).should_not be_nil
      @shop_owner.update_attributes(:address=>'exae12aaaasd2q')
      @shop_owner.errors.on(:address).should be_nil
    end
  end # END 'validate attributes'
  describe 'specific methods' do
    it 'can not create more than 1 shop' do
      lambda do
        @shop_owner.create_shop(@valid_shop_data)
      end.should_not change(Shop,:count).by(2)
    end
  end
end# 'become a shop owner'



