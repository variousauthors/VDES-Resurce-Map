class AddDefaultValueToLocationsCurrent < ActiveRecord::Migration
  def up
      change_column :locations, :current, :boolean, :default => true
  end

  def down
      change_column :locations, :current, :boolean, :default => nil
  end
end
