# To change this template, choose Tools | Templates
# and open the template in the editor.
module WeeShop
  module Liquid
    class ShopCategories < ::Liquid::Block
      include ActionView::Helpers::TagHelper
      def render(context)
        return '' if context['shop'].nil?
        css_class = @markup.split(',')
        ul_class = css_class.first
        li_class = css_class.second
        shop = context.scopes.first['shop']
        cats = []
#        controller = context.registers[:controller]
        shop.shop_categories.each do |s_cat|
          cats << content_tag(:li,"<a href='#{context['shop'][:shortname]}'>#{s_cat.name}</a>",:id=>s_cat.id,:class=>li_class)
        end
        content_tag(:ul,cats.join(), :id=>'shop-categories',:class=>ul_class)
      end
    end
  end
end