class Service < ActiveRecord::Base
  has_many :locations
  belongs_to :category

  acts_as_taggable
end
