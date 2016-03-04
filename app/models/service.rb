class Service < ActiveRecord::Base
  has_many :locations, dependent: :destroy
  belongs_to :category

  acts_as_taggable

  accepts_nested_attributes_for :locations

  validates :category, presence: true

  scope :with_location, -> {
    s = Service.arel_table
    l = Location.arel_table

    select(
      Arel.star,
      s[:id].as("id"),
      l[:address].as("address"),
      l[:phone].as("phone")
    ).joins(
      s.join(l)
      .on(
        l[:current].eq(true)
        .and(l[:service_id].eq(s[:id]))).join_sources)
  }

end
