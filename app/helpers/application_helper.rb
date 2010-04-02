# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def use_swfupload
    head_content = []
    head_content << stylesheet_link_tag('swfupload')
    head_content << javascript_include_tag('jquery-1.4.2.min','swfupload/swfupload',
                            'swfupload/swfupload.queue',
                            'swfupload/swfupload.fileprogress',
                            'swfupload/swfupload.handlers',
                            'swfupload/swfupload.config',:cache=>true)
    head_content << capture do
      content_tag :script,:type=>'text/javascript' do
             %q(var swfu;
              window.onload = function(){
              swfu = imageUploaderConfig("/images",{
              postParams:{},
              buttonImageUrl: '/images/FullyTransparent_65x29.png'
              });
             })
      end
    end
    head_content.join('')
  end
end
