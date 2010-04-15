class ProductPublisher < Facebooker::Rails::Publisher
  def product_action_template
    one_line_story_template "{*actor*} create a {*product_name*}"
    full_story_template "{*actor*} created full story", "{*product_name*}"
    action_links action_link("weeshoop notice {*link_name*}","{*link_url*}")
  end

  def attack_notification(user)
    send_as :publish_stream
    from  user
    target user
    message 'tesretet'
  end

  def product_action(user, product)
    send_as :user_action
    from  user
    story_size ONE_LINE
    data  :product_name=>product.name
  end

  def publish_create_product(user,product)
    send_as :publish_stream
    from  user
    target user
    attachment product.to_fb_attachment
    action_links [{:text=>'Join to weeshop',:href=>"http://robdoan.homedns.org:3000"}]
  end

end
