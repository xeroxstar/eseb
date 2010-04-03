require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe UsersController do
  fixtures :users

  it 'allows signup' do
    lambda do
      create_user
      response.should be_redirect
    end.should change(User, :count).by(1)
  end


  it 'signs up user in pending state' do
    create_user
    assigns(:user).reload
    assigns(:user).should be_pending
  end

  it 'signs up user with activation code' do
    create_user
    assigns(:user).reload
    assigns(:user).activation_code.should_not be_nil
  end

  it 'requires login on signup' do
    lambda do
      create_user(:login => nil)
      assigns[:user].errors.on(:login).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end


  it 'requires password on signup' do
    lambda do
      create_user(:password => nil)
      assigns[:user].errors.on(:password).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end

  it 'requires password confirmation on signup' do
    lambda do
      create_user(:password_confirmation => nil)
      assigns[:user].errors.on(:password_confirmation).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end

  it 'requires email on signup' do
    lambda do
      create_user(:email => nil)
      assigns[:user].errors.on(:email).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end


  it 'activates user' do
    User.authenticate('aaron', 'monkey').should be_nil
    get :activate, :activation_code => users(:aaron).activation_code
    response.should redirect_to('/login')
    flash[:notice].should_not be_nil
    flash[:error ].should     be_nil
    User.authenticate('aaron', 'monkey').should == users(:aaron)
  end

  it 'does not activate user without key' do
    get :activate
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end

  it 'does not activate user with blank key' do
    get :activate, :activation_code => ''
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end

  it 'does not activate user with bogus key' do
    get :activate, :activation_code => 'i_haxxor_joo'
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end
  describe 'routing' do
    describe "named routing" do
      before(:each) do
        get :new
      end
      it "should route my_account_path to /my_account" do
        my_account_path().should == "/my_account"
        my_account_path(:format => 'xml').should == "/my_account.xml"
        my_account_path(:format => 'json').should == "/my_account.json"
      end

      #TODO : should have update route action
      it "should route users_path() to /users" do
        users_path().should == "/users"
        users_path(:format => 'xml').should == "/users.xml"
        users_path(:format => 'json').should == "/users.json"
      end

      it "should route new_user_path() to /users/new" do
        new_user_path().should == "/users/new"
        new_user_path(:format => 'xml').should == "/users/new.xml"
        new_user_path(:format => 'json').should == "/users/new.json"
      end

      it "should route user_(:id => '1') to /users/1" do
        user_path(:id => '1').should == "/users/1"
        user_path(:id => '1', :format => 'xml').should == "/users/1.xml"
        user_path(:id => '1', :format => 'json').should == "/users/1.json"
      end

      it "should route my_account_path() to /my_account" do
        my_account_path().should == "/my_account"
      end
    end
    #TODO : Write spec for update user infos
  end
  describe 'update infomation' do
    fixtures :users
    before(:each) do
      @user = create_activated_user
      login_as(@user)
      @shop_owner_valid_infos = {:first_name=>"Doan",
        :last_name=>'Tran Quy',
        :address=>'37 Hung Vuong, Long Khanh, Dong nai',
        :social_id=>'B3271477',
        :city=>'Ho Chi Minh',
        :country_id=>1
      }
    end

    describe 'unlogin user' do
      before(:each) do
        logout_keeping_session!
      end
      it 'should go to login page when go to suspend page' do
        put :suspend, :id=>1
        response.should go_to_login_page
      end

      it 'should go to login page when go to unsuspend page' do
        put :unsuspend, :id=>1
        response.should go_to_login_page
      end
    end

    it 'should be able to suspend account' do
      @user = users(:quentin)
      @user.should be_active
      login_as(@user)
      put :suspend, :id=>1
      controller.current_user.should be_suspended
    end

    it 'should be able to unsuspend account' do
      @user = users(:quentin)
      login_as(@user)
      controller.current_user.should_receive(:unsuspend!)
      put :unsuspend, :id=>@user.id
    end

    describe 'edit action' do
      it 'require user must logged in' do
        logout_keeping_session!
        get 'edit'
        response.should go_to_login_page
      end

      it 'should render users/edit.html' do
        get 'edit' , :id=>@user.id
        response.template.should render_template('users/edit.html')
      end
    end

    describe 'update action' do
      it 'require user must logged in' do
        logout_keeping_session!
        put 'update',:id=>@user.id, :user=>@shop_owner_valid_infos
        response.should go_to_login_page
      end

      it 'should be redirect to create shop page when full_personal_infos' do
        put "update", :id=>@user.id, :user=>@shop_owner_valid_infos
        response.should redirect_to :controller=>'shop_admin/my_shop',:action=>'new'
      end

      it 'shoudl be render users/edit when not enought info' do
        put "update", :id=>@user.id, :user=>@shop_owner_valid_infos.merge(:address=>nil)
        response.should redirect_to my_account_path
      end
    end
  end
  def go_to_login_page
    redirect_to :controller=>'sessions',:action=>'new'
  end
  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
  end
end



