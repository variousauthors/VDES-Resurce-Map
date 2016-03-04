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

  def location=(loc)
    curr = self.location

    if curr.nil?
      self.locations << loc
    elsif curr.address != loc.address || curr.phone != loc.phone
      curr.update_attributes(current: false)
      self.locations << loc
    end
  end

  def location
    self.locations.where(current: true).first
  end

  private
    
    def unique_current_address
      if self.locations.where(current: true).count > 1
        errors.add(:locations, 'More than one current location')
      end
    end
end
