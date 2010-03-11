Given /^(?:|I) have enough personal infomations$/ do
  update_more_info(controller.current_user)
  controller.current_user.should be_full_personal_infos
end

Given /^(?:|I) do not have enough personal infomations$/ do
  controller.current_user.should_not be_full_personal_infos
end

def update_more_info(user,attrs={})
  @shop_owner_infos = {:first_name=>"Doan",
      :last_name=>'Tran Quy',
      :address=>'37 Hung Vuong, Long Khanh, Dong nai',
      :social_id=>'B3271477',
      :city=>'Ho Chi Minh',
      :country_id=>1
    }.merge(attrs)
   user.update_attributes(@shop_owner_infos)
end