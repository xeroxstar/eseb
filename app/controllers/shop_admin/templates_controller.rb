class ShopAdmin::TemplatesController < ShopAdmin::DesignController
  verify :params => :filename, :only => [:edit, :update],
    :add_flash   => { :error => 'Template required' },
    :redirect_to => { :action => 'index' }
  verify :method => :put, :params => :data, :only => :update,
    :add_flash   => { :error => 'Template required' },
    :redirect_to => { :action => 'edit' }

  def show; end

  def edit
    @tmpl = @theme.templates[params[:filename]]
  end

  def update
    @theme.templates.write(params[:filename], params[:data])
    #    shop.expire_cached_pages self, "Expired all referenced pages" if current_theme?
    render :update do |page|
      page.call 'Flash.notice', 'Template updated successfully'
    end
  end


  def create
    if params[:filename].blank? || params[:data].blank?
      render :action => 'show'
      return
    end
    if params[:filename] =~ /\.(css)\z/i
      @resource = @theme.resources.write params[:filename], params[:data]
      redirect_to url_for_theme(:controller => 'resources', :action => 'edit', :filename => @resource.basename.to_s)
    else
      @tmpl = @theme.templates.write params[:filename], params[:data]
      redirect_to "/shop_admin/templates/1/edit?filename=#{@tmpl.basename.to_s}"
    end
  end

  def remove
    if request.get?
      redirect_to :action => 'edit'
      return
    end
    @tmpl = @theme.templates[params[:filename]]
    render :update do |page|
      if !@tmpl.file?
        page.flash.errors "File does not exist"
        page.visual_effect :fade, params[:context], :duration => 0.3
      elsif @theme.templates.custom(@theme.extension).include?(@tmpl.basename.to_s)
        @tmpl.unlink
        page.visual_effect :fade, params[:context], :duration => 0.3
      else
        page.flash.errors "Cannot remove system template '#{params[:filename]}'"
      end
    end
  end
end
