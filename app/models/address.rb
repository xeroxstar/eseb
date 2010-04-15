class Address < ActiveRecord::Base
  acts_as_mappable :default_units => :miles,
    :default_formula => :sphere,
    :lat_column_name => :lat,
    :lng_column_name => :lng
  belongs_to :addressable, :polymorphic => true
  #  default_scope :include=>[:city,:country]
  
  validates_presence_of :city_id
  belongs_to :city
  belongs_to :country
  before_save :update_geocode

  def full_address
    addr = [street,state,city.name,country.name].compact
    addr.join(',')
  end

  def update_geocode
    addr = [street,state].compact
    city_country = [city.name,country.name].compact
    loc = Geokit::Geocoders::MultiGeocoder.geocode((addr + city_country ).join(','))
    while loc.lat.nil? && loc.lng.nil? && !addr.blank?
      if loc && loc.lat && loc.lng
       self.lat=loc.lat
        self.lng = loc.lng
      end
      addr.shift
      loc = Geokit::Geocoders::MultiGeocoder.geocode((addr + city_country ).join(','))
    end
    self.lat =city.latitude
    self.lng = city.longitude
  end
  
end
