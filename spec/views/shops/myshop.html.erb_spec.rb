require File.dirname(__FILE__) + '/../../spec_helper'

describe 'shops/myshop.html.erb' do
  fixtures :shops
  it 'should display shop info when shop is still active' do
    assigns[:shop] = shops(:crazy_love)
    template.should_receive(:render).with(:partial=>'shop').and_return('rendered shop')
    render 'shops/myshop'
    response.should contain('rendered shop')
    response.should have_tag('a','Deactive')
  end

  it 'should display reactive link when shop is unactive' do
    assigns[:shop] = shops(:pinky_love)
    assigns[:shop].status.should == 2
    render 'shops/myshop'
    response.should have_tag('a','Reactive')
  end

end