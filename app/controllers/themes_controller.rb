class ThemesController < ApplicationController
  def preview_for
    @theme = Theme.global_themes[params[:id]]
    send_file((@theme.preview.exist? ? @theme.preview : RAILS_PATH + 'public/images/mephisto/preview.png').to_s, :type => 'image/png', :disposition => 'inline')
  end

  def index
  end
end
