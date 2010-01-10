# To change this template, choose Tools | Templates
# and open the template in the editor.

module MockTestHelpers
  def mock_shop_owner
    shop_owner = stub_model(ShopOwner, :id=>1,
      :first_name=>"Doan",
      :last_name=>'Tran Quy',
      :address=>'37 Hung Vuong, Long Khanh, Dong nai',
      :social_id=>'B3271477',
      :city=>'Ho Chi Minh',
      :country_id=>1,
      :login  => 'Quy doan',
      :email => 'quydoantran' )
    shop_owner
  end
  def mock_shop
    shop = mock_model(Shop,:shortname=>'quydoan',:name=>'Quynh Khanh')
    shop
  end

end
