class Country < ActiveRecord::Base
  has_many :cities
  validates_presence_of :name,:code
end