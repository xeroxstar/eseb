Liquid::Template.register_tag 'shopcategries', WeeShop::Liquid::ShopCategories
Liquid::Template.register_filter UrlFilters
unless Object.const_defined?(:THEME_ROOT)
  THEME_ROOT = Pathname.new(RAILS_ROOT) +
    (Rails.env.production? ? "themes" : "themes/#{Rails.env}")
end
RAILS_PATH = Pathname.new(File.expand_path(RAILS_ROOT))