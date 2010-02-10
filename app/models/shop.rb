class Shop < ActiveRecord::Base
  ACTIVE = 1
  DEACTIVE = 2
  SHORTNAME_FORMAT = /^[a-zA-Z0-9\-]{3,}$/i
  belongs_to :owner, :class_name=>'ShopOwner', :foreign_key=>'user_id'

  #validation
  validates_presence_of     :shortname
  validates_format_of       :shortname , :with=>SHORTNAME_FORMAT
  validates_uniqueness_of   :shortname

  validates_presence_of     :name

  validates_uniqueness_of   :user_id

  def unactive?
    self.status == DEACTIVE
  end

  def activate
    update_attribute(:status,ACTIVE)
  end

  def deactivate
    update_attribute(:status,DEACTIVE)
  end

end