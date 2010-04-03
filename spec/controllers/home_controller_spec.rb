# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do
  describe 'no require login' do
    before(:each) do
      logout_keeping_session!
    end
    it 'home page' do
      get :index
      response.should render_template('home/index.html')
    end
  end
end

