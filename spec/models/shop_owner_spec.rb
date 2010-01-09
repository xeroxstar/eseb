require File.dirname(__FILE__) + '/../spec_helper'

describe ShopOwner do
  fixtures :users
  describe 'become a shop owner' do
    before(:each) do
      @user = users(:quentin)
    end

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

  end# 'become a shop owner'
  protected
  def become_shop_owner(shop_owner_attrs={})
    @shop = users(:quentin)
    @shop_owner_infos = {:first_name=>"Doan",
      :last_name=>'Tran Quy',
      :address=>'37 Hung Vuong, Long Khanh, Dong nai',
      :social_id=>'B3271477',
      :city=>'Ho Chi Minh',
      :country_id=>1
      }.merge(shop_owner_attrs)
    @user.update_attributes(@shop_owner_infos)
    @user
  end

end