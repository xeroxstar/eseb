require File.dirname(__FILE__) + '/../../spec_helper'

describe 'users/_informations_form.html.erb' do
  fixtures :countries
  before(:each) do
    @user =  mock_full_info_user_model
    @country = countries(:vietnam)
  end
  it 'should render the all user infomation' do
    render 'users/_informations_form.html', {:locals=>{:user=>@user}}
    response.should have_selector("form",:action=>user_path(@user)) do |form|
      form.should contain(@user.login)
      form.should contain(@user.email)
      form.should have_selector('input[type=text]',:name=>'user[first_name]',:value=>@user.first_name)
      form.should have_selector('input[type=text]',:name=>'user[last_name]',:value=>@user.last_name)
      form.should have_selector('input[type=text]',:name=>'user[social_id]',:value=>@user.social_id)
      form.should have_selector('input[type=text]',:name=>'user[address]',:value=>@user.address)
      form.should have_selector('input[type=text]',:name=>'user[city]',:value=>@user.city)
      form.should have_selector('select',:name=>'user[country_id]')
      form.should have_selector('select option',:content=>@country.name)
      form.should have_selector('select option',:content=>'Select a country')
    end
  end
end