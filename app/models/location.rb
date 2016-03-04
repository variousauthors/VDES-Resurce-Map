class Location < ActiveRecord::Base
  belongs_to :service

  validates :address, presence: true, allow_blank: false
  validates :phone, presence: true, allow_blank: false
end
