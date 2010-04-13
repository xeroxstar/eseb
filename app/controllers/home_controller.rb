class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.fbml
      format.html
    end
  end
end