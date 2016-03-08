class Service < ActiveRecord::Base
  has_many :locations, dependent: :destroy
  belongs_to :category

  acts_as_taggable

  accepts_nested_attributes_for :locations

  validates :category, presence: true
  validates :locations, presence: true

  scope :with_location, -> {
    s = Service.arel_table
    l = Location.arel_table

    # recent locations
    x = l.project(
      l[:service_id].as("xs_id"),
      l[:created_at].maximum.as("created_at"))
      .group(l[:service_id])
      .as("X")

    # subquery for join: 
    y = l.project(
      l[:address].as("address"),
      l[:phone].as("phone"),
      l[:id].as("id"), 
      l[:service_id].as("ys_id"), 
      x[:created_at].as("created_at"))
      .join(x)
      .on(x[:xs_id].eq(l[:service_id])
      .and(x[:created_at].eq(l[:created_at])))
      .as("Y")

    select(
      Arel.star,
      s[:id].as("id"),
      y[:address].as("address"),
      y[:phone].as("phone")
    ).joins(
      s.join(y)
      .on(y[:ys_id].eq(s[:id])).join_sources)
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
