class ShopAdmin::DesignController < ShopAdmin::ApplicationController
  before_filter :find_theme

  protected
  def find_theme
    @theme = params[:theme] ? shop.themes[params[:theme]] : shop.theme
    raise ThemeNotFound,'Theme not found' unless @theme
  end

  def current_theme?
    shop.theme.base_path == @theme.base_path
  end

  def url_for_theme(options)
    @theme.current? ? options : options.update(:theme => @theme.name)
  end
  helper_method :url_for_theme
end
