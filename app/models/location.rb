class Location < ActiveRecord::Base
  belongs_to :service

  attr_readonly :address, :phone, :service_id

  geocoded_by :address
  after_validation :geocode

  validates :address, presence: true, allow_blank: false
  validates :phone, presence: true, allow_blank: false
end
