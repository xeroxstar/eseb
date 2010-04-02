# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
include AuthenticatedTestHelper

describe User do
  before(:each) do
    @country = Country.make
    @shop_owner_infos = {:first_name=>"Doan",
      :last_name=>'Tran Quy',
      :address=>'37 Hung Vuong, Long Khanh, Dong nai',
      :social_id=>'B3271477',
      :city=>'Ho Chi Minh',
      :country=>@country
    }
  end
  describe 'being created' do
    before do
      @user = User.new(:login=>Sham.login,:email=>Sham.email,:password=>'password',:password_confirmation=>'password')
    end

    it 'increments User#count' do
      lambda{
        @user.register!
      }.should change(User, :count).by(1)
    end

    it 'initializes #activation_code' do
      @user.register!
      @user.activation_code.should_not be_nil
    end

    it 'starts in pending state' do
      @user.register!
      @user.should be_pending
    end
  end

  it 'requires login' do
    lambda do
      u = User.make_unsaved(:login => nil)
      u.save
      u.errors.on(:login).should_not be_nil
    end.should_not change(User, :count)
  end

  describe 'allows legitimate logins:' do
    ['123', '1234567890_234567890_234567890_234567890',
      'hello.-_there@funnychar.com'].each do |login_str|
      it "'#{login_str}'" do
        lambda do
          u = User.make_unsaved(:login => login_str)
          u.save
          u.errors.on(:login).should     be_nil
        end.should change(User, :count).by(1)
      end
    end
  end
  describe 'disallows illegitimate logins:' do
    ['12', '1234567890_234567890_234567890_234567890_', "tab\t", "newline\n",
      "Iñtërnâtiônàlizætiøn hasn't happened to ruby 1.8 yet",
      'semicolon;', 'quote"', 'tick\'', 'backtick`', 'percent%', 'plus+', 'space '].each do |login_str|
      it "'#{login_str}'" do
        lambda do
          u = User.make_unsaved(:login => login_str)
          u.save
          u.errors.on(:login).should_not be_nil
        end.should_not change(User, :count)
      end
    end
  end

  it 'requires password' do
    lambda do
      u = User.make_unsaved(:password => nil)
      u.save
      u.errors.on(:password).should_not be_nil
    end.should_not change(User, :count)
  end

  it 'requires password confirmation' do
    lambda do
      u = User.make_unsaved(:password_confirmation => nil)
      u.save
      u.errors.on(:password_confirmation).should_not be_nil
    end.should_not change(User, :count)
  end

  it 'requires email' do
    lambda do
      u = User.make_unsaved(:email => nil)
      u.save
      u.errors.on(:email).should_not be_nil
    end.should_not change(User, :count)
  end

  describe 'allows legitimate emails:' do
    ['foo@bar.com', 'foo@newskool-tld.museum', 'foo@twoletter-tld.de', 'foo@nonexistant-tld.qq',
      'r@a.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail.com',
      'hello.-_there@funnychar.com', 'uucp%addr@gmail.com', 'hello+routing-str@gmail.com',
      'domain@can.haz.many.sub.doma.in', 'student.name@university.edu'
    ].each do |email_str|
      it "'#{email_str}'" do
        lambda do
          u = User.make_unsaved(:email => email_str)
          u.save
          u.errors.on(:email).should     be_nil
        end.should change(User, :count).by(1)
      end
    end
  end
  describe 'disallows illegitimate emails' do
    ['!!@nobadchars.com', 'foo@no-rep-dots..com', 'foo@badtld.xxx', 'foo@toolongtld.abcdefg',
      'Iñtërnâtiônàlizætiøn@hasnt.happened.to.email', 'need.domain.and.tld@de', "tab\t", "newline\n",
      'r@.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail2.com',
      # these are technically allowed but not seen in practice:
      'uucp!addr@gmail.com', 'semicolon;@gmail.com', 'quote"@gmail.com', 'tick\'@gmail.com', 'backtick`@gmail.com', 'space @gmail.com', 'bracket<@gmail.com', 'bracket>@gmail.com'
    ].each do |email_str|
      it "'#{email_str}'" do
        lambda do
          u = User.make_unsaved(:email => email_str)
          u.save
          u.errors.on(:email).should_not be_nil
        end.should_not change(User, :count)
      end
    end
  end

  describe 'allows legitimate names:' do
    ['Andre The Giant (7\'4", 520 lb.) -- has a posse',
      '', '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890',
    ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = User.make_unsaved(:name => name_str)
          u.save
          u.errors.on(:name).should     be_nil
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "disallows illegitimate names" do
    ["tab\t", "newline\n",
      '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_',
    ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = User.make_unsaved(:name => name_str)
          u.save
          u.errors.on(:name).should_not be_nil
        end.should_not change(User, :count)
      end
    end
  end

  #
  # Authentication
  #
  describe 'Authentication' do
    before(:each) do
      @user = User.make_unsaved(:login=>'quentin',:email=>'quentin@example.com')
      @user.register!
      @user.activate!
    end

    it 'resets password' do
      @user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
      User.authenticate('quentin', 'new password').should == @user
    end

    it 'does not rehash password' do
      @user.update_attributes(:login => 'quentin2')
      User.authenticate('quentin2', 'password').should == @user
    end

    it 'authenticates user' do
      User.authenticate('quentin', 'password').should == @user
    end

    it "doesn't authenticate user with bad password" do
      User.authenticate('quentin', 'invalid_password').should be_nil
    end

    it "should be authenticate by password and email" do
      User.authenticate('quentin@example.com', 'password').should == @user
    end

    it 'should not authenticate with wrong email' do
      User.authenticate('wrongquentin@example.com', 'password').should_not == @user
    end

    if REST_AUTH_SITE_KEY.blank?
      # old-school passwords
      it "authenticates a user against a hard-coded old-style password" do
        User.authenticate('old_password_holder', 'test').should == users(:old_password_holder)
      end
    else
      it "doesn't authenticate a user against a hard-coded old-style password" do
        User.authenticate('old_password_holder', 'test').should be_nil
      end

      # New installs should bump this up and set REST_AUTH_DIGEST_STRETCHES to give a 10ms encrypt time or so
      desired_encryption_expensiveness_ms = 0.1
      it "takes longer than #{desired_encryption_expensiveness_ms}ms to encrypt a password" do
        test_reps = 100
        start_time = Time.now; test_reps.times{ User.authenticate('quentin', 'monkey'+rand.to_s) }; end_time   = Time.now
        auth_time_ms = 1000 * (end_time - start_time)/test_reps
        auth_time_ms.should > desired_encryption_expensiveness_ms
      end
    end
  end


  it 'have engouh information when it filled first_name, last_name, city, adrress and country' do
    @user = User.make(@shop_owner_infos)
    @user.should be_full_personal_infos
  end

  [:last_name,:first_name,:city,:address].each do |attr|
    it "have not engouh informations when it missing #{attr}" do
      @user = User.make(attr=>nil)
      @user.should_not be_full_personal_infos
    end
  end

  #  it 'registers passive user' do
  #    user = create_user(:password => nil, :password_confirmation => nil)
  #    user.should be_passive
  #    user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
  #    user.register!
  #    user.should be_pending
  #  end
  describe 'remember me and supends' do
    before(:each) do
      @user = User.make()
    end
    it 'remembers me for one week' do
      before = 1.week.from_now.utc
      @user.remember_me_for 1.week
      after = 1.week.from_now.utc
      @user.remember_token.should_not be_nil
      @user.remember_token_expires_at.should_not be_nil
      @user.remember_token_expires_at.between?(before, after).should be_true
    end

    it 'sets remember token' do
      @user.remember_me
      @user.remember_token.should_not be_nil
      @user.remember_token_expires_at.should_not be_nil
    end

    it 'unsets remember token' do
      @user.remember_me
      @user.remember_token.should_not be_nil
      @user.forget_me
      @user.remember_token.should be_nil
    end
    it 'remembers me until one week' do
      time = 1.week.from_now.utc
      @user.remember_me_until time
      @user.remember_token.should_not be_nil
      @user.remember_token_expires_at.should_not be_nil
      @user.remember_token_expires_at.should == time
    end

    it 'remembers me default two weeks' do
      before = 2.weeks.from_now.utc
      @user.remember_me
      after = 2.weeks.from_now.utc
      @user.remember_token.should_not be_nil
      @user.remember_token_expires_at.should_not be_nil
      @user.remember_token_expires_at.between?(before, after).should be_true
    end

    it 'suspends user' do
      @user.suspend!
      @user.should be_suspended
    end

    it 'does not authenticate suspended user' do
      @user.suspend!
      User.authenticate(@user.login, 'password').should_not == @user
    end
  end

  it 'deletes user' do
    user = User.make(:deleted_at=>nil)
    user.save!
    user.delete!
    user.should be_deleted
  end

  describe "being unsuspended" do
#    fixtures :users

    before do
      @user = User.make(:activated_at=>2.days.ago)
      @user.suspend!
    end

    it 'reverts to active state' do
      @user.unsuspend!
      @user.should be_active
    end

    it 'reverts to passive state if activation_code and activated_at are nil' do
      User.update_all :activation_code => nil, :activated_at => nil
      @user.reload.unsuspend!
      @user.should be_passive
    end

    it 'reverts to pending state if activation_code is set and activated_at is nil' do
      User.update_all :activation_code => 'foo-bar', :activated_at => nil
      @user.reload.unsuspend!
      @user.should be_pending
    end
  end
  describe 'email notification' do
    include EmailSpec::Helpers
    include EmailSpec::Matchers

    before(:each) do
      #      create_user
    end
    it 'should be send a sign up notificaiton after user register' do
      UserMailer.should_receive(:deliver_signup_notification)
      user = create_user
      @email = UserMailer.create_signup_notification(user)
      @email.should deliver_to(user.email)
      user.should be_pending
    end

    it 'should not send a sign up notificaiton when register unsuccessful' do
      UserMailer.should_not_receive(:deliver_signup_notification)
      user = User.make_unsaved(:password=>nil)
      user.save
    end
  end
  describe 'util methods' do
    before(:each) do
      @user = User.make
      @shopowner = User.make(@shop_owner_infos)
    end
    ['city','first_name','last_name','address','social_id','city','country_id'].each do |attr|
      it "full_personal_infos? should return false if #{attr} nil or blank" do
        @shopowner.should be_full_personal_infos
        @shopowner.update_attribute(attr.to_sym,nil)
        @shopowner.should_not be_full_personal_infos
      end
    end

    it 'should be able to create a shop if full_personal_infos?' do
      @shopowner.should be_full_personal_infos
      lambda {
        @shopowner.create_shop(:name=>'Rob Doan',:shortname=>'loveshop',:category_id=>1).should be_kind_of(Shop)
      }.should change(Shop, :count).by(1)
    end

    it 'should not be able to create a shop unless full_personal_infos?' do
      @user.should_not be_full_personal_infos
      lambda {
        @user.create_shop(:name=>'Rob Doan',:shortname=>'loveshop').should be_nil
      }.should change(Shop, :count).by(0)
    end

    it 'should not be able to create a shop when already have shop' do
      lambda{
        @shopowner.create_shop(:name=>'Rob Doan',:shortname=>'loveshop')
      }.should_not change(Shop,:count)
    end

  end

  protected
  def create_user(options = {})
    record = User.make(options)
    record.register! if record.valid?
    record
  end

  def update_full_info(shop_owner_attrs={})
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
