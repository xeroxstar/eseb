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

  validates_format_of       :first_name, :with=>NAME_REG, :allow_blank =>true

  validates_format_of       :last_name, :with=>NAME_REG , :allow_blank =>true


  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation,
    :first_name, :last_name, :social_id
  after_create :register_user_to_fb


  # Asccociation
  #  belongs_to :country
  has_many :products
  has_one :address, :as=>:addressable
  has_one :shop, :foreign_key => 'user_id'
  #  accepts_nested_attributes_for :address

  #  class << self
  #    # This method is worked with the single-table inheritance model.
  #    # Create ShopOwner object when user record have enough infomation
  #    #    def instantiate(record)
  #    #      if Shop.exists?(:user_id=>record['id'])
  #    #        record[inheritance_column] = 'ShopOwner'
  #    #      end
  #    #      super(record)
  #    #    end
  #  end

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
    return !(first_name.blank? || last_name.blank? || social_id.blank? || address.nil?)
  end

  def address=(value)
    return if value.nil?
    if value.is_a?(Hash)
      if address
        self.address.update_attributes(value)
      else
        self.create_address(value)
      end
    else
      raise ArgumentError, "The value must be a Hash"
    end
  end

  def lat
    address.lat
  end

  def lng
    address.lng
  end

  def shops_near_me(distances)
    shop_addresses = Address.find(:all,:within=>distances,:conditions=>["addressable_type= ?",'Shop'],:origin=>[self.lat,self.lng])
    Shop.all(:conditions=>{:id=>shop_addresses.map(&:addressable_id)})
  end

  def update_attributes(attributes)
    addr = attributes.delete(:address)
    if addr
      self.address= addr
    end
    super(attributes)
  end

  # Create shop
  def create_shop(attrs={})
    shop_attrs = attrs.merge(:user_id=>id)
    shop = Shop.new(shop_attrs)
    shop.status = Shop::PENDING
    shop.save
    shop
  end

  def owner?(shop)
    return (id==shop.user_id)
  end

  # ==============Facebook Feature========================

  #find the user in the database, first by the facebook user id and if that fails through the email hash
  def self.find_by_fb_user(fb_user)
    User.find_by_fb_id(fb_user.uid) || User.find_by_email_hash(fb_user.email_hashes)
  end

  #Take the data returned from facebook and create a new user from it.
  #We don't get the email from Facebook and because a facebooker can only login through Connect we just generate a unique login name for them.
  #If you were using username to display to people you might want to get them to select one after registering through Facebook Connect
  def self.create_from_fb_connect(fb_user)
    new_facebooker = User.new(:username => "fb_#{fb_user.uid}", :password => "", :email => "")
    new_facebooker.fb_id = fb_user.uid.to_i

    #We need to save without validations
    new_facebooker.save(false)
    new_facebooker.register_user_to_fb
  end


  #We are going to connect this user object with a facebook id. But only ever one account.
  def link_fb_connect(fb_id)
    unless fb_id.nil?
      #check for existing account
      existing_fb_user = User.find_by_fb_id(fb_id)

      #unlink the existing account
      unless existing_fb_user.nil?
        existing_fb_user.fb_id = nil
        existing_fb_user.save(false)
      end

      #link the new one
      self.fb_id = fb_id
      save(false)
    end
  end

  #The Facebook registers user method is going to send the users email hash and our account id to Facebook
  #We need this so Facebook can find friends on our local application even if they have not connect through connect
  #We hen use the email hash in the database to later identify a user from Facebook with a local user
  def register_user_to_fb
    unless fb_id
      users = {:email => email, :account_id => id}
      Facebooker::User.register([users])
      self.email_hash = Facebooker::User.hash_email(email)
      save(false)
    end
  end

  def facebook_user?
    return !fb_id.nil? && fb_id > 0
  end

  def fb_user
    return :false if fb_id.nil?
    Facebooker::User.new(fb_id)
  end

  def publish_product(product,images_ids=[])
    if fb_user && fb_user.has_permission?('publish_stream')
      attachment = {:caption=>"{*actor*} posted from weeshop",
        :description=>"#{product.description}"}
      medias = []
      for image in Image.with_ids(images_ids) do
        medias << {:type=>'image',
          :src=>"http://robdoan.homedns.org:3000#{image.attachment.url(:mini)}",
          :href=>"http://robdoan.homedns.org:3000#{image.attachment.url(:product)}" }
      end
      if !medias.blank?
        attachment = attachment.merge(:media=>medias)
      end
      if shop
        attachment =attachment.merge({:name=>"#{shop.name} shop", :href=>"http://robdoan.homedns.org:3000/#{shop.shortname}"})
      end
      fb_user.publish_to(fb_user,:message=>"created  new #{product.name}",
        :attachment=>attachment)
    end
  end

  def publish_created_shop
    if fb_user && fb_user.has_permission?('publish_stream')
      ProductPublisher.deliver(fb_user,shop)
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
