class ShopAdmin::ApplicationController < ApplicationController
  layout 'admin'
  before_filter :login_required,:owner_of_shop
  helper_method :shop
  attr_reader :shop
end
