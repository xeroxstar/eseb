class City < ActiveRecord::Base
  belongs_to :country
  validates_presence_of :name

  class << self
    def city_collection
      return City.all(:conditions=>{:country_id=>260}).collect{|c| [c.name,c.id]}
    end
  end
end
