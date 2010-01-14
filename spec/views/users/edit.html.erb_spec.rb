require File.dirname(__FILE__) + '/../../spec_helper'
include MockTestHelpers
describe 'users/edit.html.erb' do
  before(:each) do
    @user =  mock_full_info_user_model
    assigns[:user] = @user
  end
  it 'should render partail users/informations_form' do
    template.stub!(:current_user).and_return(@user)
    @user.stub!(:full_personal_infos?).and_return(false)
    template.should_receive(:render).with({
          :partial=>'informations_form',
          :locals=>{:user=>@user}
      }).and_return('rendered from infomations_form partial')
    render 'users/edit'
    response.should contain('rendered from infomations_form partial')
  end
end