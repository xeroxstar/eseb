require File.dirname(__FILE__) + '/../spec_helper'

describe ShopOwner do
  fixtures :users
  before(:each) do
    @user = users(:quentin)
  end
  describe 'become a shop owner' do
    it 'user should be able to become a shop owner' do
      lambda {become_shop_owner()}.should change(ShopOwner,:count).by(1)
    end

    describe 'require attributes' do
      ['first_name','last_name', 'address','social_id',
        'city', 'country_id'].each do |item|
        it "'#{item}'" do
          lambda {become_shop_owner({item.to_sym=>nil})}.should_not change(ShopOwner,:count).by(1)
        end
      end # End of Each loop
    end#end 'require attributes'

    describe 'validate attributes' do
      it 'lenght of first name and last name should more than 3' do
        become_shop_owner(:first_name=>'aa',:last_name=>'cc')
        @user.errors.on(:first_name).should_not be_nil
        @user.errors.on(:last_name).should_not be_nil
      end

      describe 'legitimate last and first name' do
        ['a bac','quynh-pham','a.Sen','ten gii'].each do |name|
          it "'#{name}'" do
            become_shop_owner(:first_name=>name,:last_name=>name)
            @user.errors.on(:first_name).should be_nil
            @user.errors.on(:last_name).should be_nil
          end
        end
      end#END 'legitimate last and first name'

      describe 'illegitimate last and first name' do
        ['a@bac','quynh|pham','a(Sen','ten99+asgii'].each do |name|
          it "'#{name}'" do
            become_shop_owner(:first_name=>name,:last_name=>name)
            @user.errors.on(:first_name).should_not be_nil
            @user.errors.on(:last_name).should_not be_nil
          end
        end
      end#END 'legitimate last and first name'

      it 'lenght of address should more than 12 characters' do
        become_shop_owner(:address=>'exae12aaa')
        @user.errors.on(:address).should_not be_nil
        become_shop_owner(:address=>'exae12aaaasd2q')
        @user.errors.on(:address).should be_nil
      end
    end # END 'validate attributes'
  end# 'become a shop owner'

  describe 'specific methods' do
    before(:each) do
      become_shop_owner
      @shop_owner = ShopOwner.find(@user.id)
      @valid_shop_data = {:name=>'quynhkhanh',:shortname=>'quynhkhanh'}
    end
    it 'create a shop successfull' do
      lambda{
        @shop_owner.create_shop(@valid_shop_data).should be_a_kind_of(Shop)
      }.should change(Shop,:count).by(1)
    end

    it 'can not create more than 1 shop' do
      lambda do
        @shop_owner.create_shop(@valid_shop_data)
        @shop = @shop_owner.create_shop(@valid_shop_data.merge(:shortname=>'quynhkhanh2'))
        @shop.errors.should_not be_empty
      end.should_not change(Shop,:count).by(2)
    end

    it 'create a shop unsuccessfull with invailid shop data' do
      lambda{
        @shop_owner.create_shop(@valid_shop_data.merge(:shortname=>nil))
      }.should_not change(Shop,:count).by(1)
    end

  end
  protected
  def become_shop_owner(shop_owner_attrs={})
    @shop_owner_infos = {:first_name=>"Doan",
      :last_name=>'Tran Quy',
      :address=>'37 Hung Vuong, Long Khanh, Dong nai',
      :social_id=>'B3271477',
      :city=>'Ho Chi Minh',
      :country_id=>1
    }.merge(shop_owner_attrs)
    @user.update_attributes(@shop_owner_infos)
  end

end