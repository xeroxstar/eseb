class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.fbml
      format.html{
#                render :text=>
#        product = Product.first
#        #        ProductPublisher.deliver_product_action(facebook_session.user,product)
#        a = Facebooker::Feed::Action.new()
#        a.title = "#{facebook_session.user.name} created #{product.name}"
#        a.body = "@#{facebook_session.user.name} created #{product.name}"
#        facebook_session.user.publish_to(facebook_session.user,
#          :message=>"@#{facebook_session.user.name} created #{product.name}",
#          :attachment=>{:name=>'Quynh Khanh Shop',
#                        :href=>'http://localhost:3000/shops/quynhkhanh',
#                        :caption=>"{*actor*} created product",
#                        :description=>'Quynh Khanh SHop',
#                        :media=>[{:type=> 'image',
#                            :src=> 'http://kwc.org/blog/resources/2010/google-nexus-one.jpg',
#                            :href=>'http://kwc.org/blog/resources/2010/google-nexus-one.jpg'}]
#          })
      }
    end
  end
end