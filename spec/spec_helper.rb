# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'
require "email_spec/helpers"
require "email_spec/matchers"
require "mock_test_helpers"
require "webrat"
require 'util_helper'
require 'machinist'
require File.join(File.dirname(__FILE__), 'blueprints')
# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}
include AuthenticatedTestHelper
Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.include Webrat::Matchers , :type=>:views
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.before(:each) { Sham.reset }
  #  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  #  config.global_fixtures = :all
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end
Spec::Rails::Example::ControllerExampleGroup.send(:include,AuthenticatedSystem)
Spec::Rails::Example::ControllerExampleGroup.send(:include,UtilHelper)
def create_activated_shopowner(attrs={})
#  attrs = {:country=>Country.make}.merge(attrs)
  shop_owner  = ShopOwner.make_unsaved(attrs)
  shop_owner.register!
  shop_owner.activate!
  Address.make(:addressable=>shop_owner)
  shop_owner
end

def create_activated_user(attrs={})
  user  = User.make_unsaved(attrs)
  user.register!
  user.activate!
  user
end

def valid_shop(attr={})
  return {:name=>Sham.name,:shortname=>Sham.shortname,:category_id=>1}.merge(attr)
end
def valid_product(attr={})
  return {:name=>Sham.name}.merge(attr)
end
def valid_shop_category(attr={})
  subcategory = Category.make(:subcategory)
  return {:name=>Sham.name,:subcategory_id=>subcategory.id}.merge(attr)
end

def valid_address(attr={})
  country = Country.make
  city = City.make(:country_id=>country.id)
  return {:street=>Sham.street,:state=>Sham.name,:city_id=>city.id}.merge(attr)
end