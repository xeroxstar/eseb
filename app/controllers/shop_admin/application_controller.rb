class ShopAdmin::ApplicationController < ApplicationController
  before_filter :login_required,:owner_of_shop
end
