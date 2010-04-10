class AssetDrop < BaseDrop
  #  liquid_attributes.push(*[:content_type, :size, :filename, :width, :height, :title])

  #  [:image, :movie, :audio, :other, :pdf].each do |content|
  #    define_method("is_#{content}") { @source.send("#{content}?") }
  #  end

  #  def tags
  #    @tags ||= liquify *@source.tags
  #  end

  #  def path
  #    @path = @source.public_filename
  #  end
  def initialize(source,options={})
    super source
  end

  [:mini, :small, :product, :large ].each do |style|
    define_method("#{style}_image_url") { @source.attachment.send(:url,style) }
  end
end
