class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.references :category, index: true, foreign_key: true
      t.boolean :active
      t.datetime :modified_at # when the model was last _meaningfully_ updated

      t.timestamps null: false
    end
  end
end
