class Service < ActiveRecord::Base
  has_many :locations, dependent: :destroy
  belongs_to :category

  acts_as_taggable

  accepts_nested_attributes_for :locations

  validates :category, presence: true
  validates :locations, presence: true
  validate :unique_current_address

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

  scope :with_category_name, -> {
    s = Service.arel_table
    c = Category.arel_table

    select(
      Arel.star,
      s[:id].as("id"),
      s[:name].as("name"),
      c[:name].as("category_name"),
    ).joins(
      s.join(c)
      .on(
        s[:category_id].eq(c[:id])).join_sources)
  }

  def current_location
    self.locations.last
  end
end
