class CreateSearchItems < ActiveRecord::Migration[5.0]
  def change
    create_table :search_items do |t|
      t.float :lat
      t.float :lng
      t.string :short_name
      t.string :hint
      t.string :full_name

      t.timestamps
    end
  end
end
