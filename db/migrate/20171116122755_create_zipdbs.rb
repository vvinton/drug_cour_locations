class CreateZipdbs < ActiveRecord::Migration[5.0]
  def change
    create_table :zipdbs do |t|
      t.integer :zip
      t.float :lng
      t.float :lat
      t.string :city
      t.string :state
      t.string :county

      t.timestamps
    end
  end
end
