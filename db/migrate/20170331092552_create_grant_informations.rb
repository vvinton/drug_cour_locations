class CreateGrantInformations < ActiveRecord::Migration[5.0]
  def change
    create_table :grant_informations do |t|
      t.belongs_to :program_information, index: true
      t.string  :agency
      t.string  :grant_number
      t.integer :grant_year
      t.string  :grant_type
      t.string  :amount
      t.timestamps
    end
  end
end
