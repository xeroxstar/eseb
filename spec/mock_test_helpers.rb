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

  def mock_full_info_user_model
    user = mock_model(User,{:login=>'quydoan',
        :email=>'quydoantran@gmail.com',
        :first_name=>'Quy',
        :last_name=>'Doan',
        :social_id=>'2714663213',
        :address=>'37 Hung Vuong Long Khanh Dong Nai',
        :city=>'Dong Nai',
        :country_id=>'1'})
    user
  end


end
