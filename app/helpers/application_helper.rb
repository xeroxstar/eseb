# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def use_swfupload
    head_content = []
    head_content << stylesheet_link_tag('swfupload')
    head_content << javascript_include_tag('swfupload/swfupload',
      'swfupload/swfupload.queue',
      'swfupload/swfupload.fileprogress',
      'swfupload/swfupload.handlers',
      'swfupload/swfupload.config',:cache=>true)
    onload_js =  capture do
      %q(
              imageUploaderConfig("/images",{
              postParams:{},
              buttonImageUrl: '/images/FullyTransparent_65x29.png'
              });
      )
    end
    if @content_for_onload_js
      @content_for_onload_js +=onload_js
    else
      @content_for_onload_js =onload_js
    end
    head_content.join('')
  end

  def use_fancybox
    head_content = []
    head_content << javascript_include_tag('fancybox/jquery.mousewheel-3.0.2.pack',
      'fancybox/jquery.fancybox-1.3.1',
      :cache=>true)
    head_content << stylesheet_link_tag('fancybox/jquery.fancybox-1.3.1')
    onload_js =  capture do
      %q( $(".fancy-links").fancybox({autoScale:false,autoDimensions:true,scrolling: 'no',type:'ajax'});)
    end
    if @content_for_onload_js
      @content_for_onload_js +=onload_js
    else
      @content_for_onload_js =onload_js
    end
    head_content.join('')
  end

  # Generate fancy box link
  def fancy_link(*args,&block)
     if block_given?
       args[1]= args.second||{}
       args[1] = args[1].merge({:class=>'fancy-links'})
       return link_to(*args,&block)
     else
       args[2] =args.third || {}
       args[2] = args[2].merge({:class=>'fancy-links'})
       return link_to(*args,&block)
     end

  end
end
