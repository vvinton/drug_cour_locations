class CreateSearchItemLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :search_item_locations do |t|
      t.integer :search_item_id
      t.integer :program_information_id

      t.timestamps
    end
  end
end
