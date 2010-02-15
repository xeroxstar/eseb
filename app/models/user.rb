require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  NAME_REG = /^[a-z0-9\-\.\s]{3,}$/ix

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  validates_format_of       :first_name, :with=>NAME_REG, :allow_nil =>true

  validates_format_of       :last_name, :with=>NAME_REG , :allow_nil =>true

  validates_length_of       :address, :minimum=>12, :allow_blank=>true



  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation,
    :first_name, :last_name,:address, :social_id,:country_id,:city


  # Asccociation
  belongs_to :country
  #  has_one :shop

  class << self
    # This method is worked with the single-table inheritance model.
    # Create ShopOwner object when user record have enough infomation
    def instantiate(record)
      if Shop.exists?(:user_id=>record['id'])
        record[inheritance_column] = 'ShopOwner'
      end
      super(record)
    end
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_in_state :first, :active,
      :conditions => ["login = ? or email = ?",login.downcase,login.downcase]
    ## need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  # Check user whether have enough personal infos or not to create a shop
  #   return true. When first_name, last_name, city, address, country is not nil
  def full_personal_infos?
    return !(first_name.blank? || last_name.blank? || social_id.blank? || city.blank? || address.blank? || country.blank?)
  end

  # Create shop
  def create_shop(attrs={})
    if full_personal_infos?
      shop_attrs = attrs.merge(:user_id=>id)
      shop = Shop.new(shop_attrs)
      shop.save
      self.reload
      shop
    end
  end

  protected

  # does user have a shop?
  #  def has_shop?
  #    return shop
  #  end

  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end



end
