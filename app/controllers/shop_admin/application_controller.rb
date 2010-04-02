class ShopAdmin::ApplicationController < ApplicationController
  before_filter :owner_of_shop
end
