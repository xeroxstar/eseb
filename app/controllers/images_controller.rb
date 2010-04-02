class ImagesController < ApplicationController
  layout false
  protect_from_forgery :except => [:create, :destroy]
  def new

  end
  def create
    if params[:Filedata]
      @image = Image.new(:attachment => params[:Filedata])
      if @image.save
        render :json=>{:image_url=>@image.attachment.url(:mini),:id=>@image.id}
      else
        render :text => "error", :status=>500
      end
    else
      @image = Image.new params[:image]
      if @image.save
        flash[:notice] = 'Your image has been uploaded!'
        redirect_to photos_path
      else
        render :action => :new
      end
    end
  end
end
