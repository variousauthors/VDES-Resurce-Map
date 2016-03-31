class AddNotesToServices < ActiveRecord::Migration
  def change
    add_column :services, :notes, :text
  end
end
