class CreateJurisdictionInformations < ActiveRecord::Migration[5.0]
  def change
    create_table :jurisdiction_informations do |t|
      t.belongs_to :program_information, index: true
      t.string :jurisdiction_type
      t.string :square_mileage
      t.string :population
      t.string :population_data_year
      t.string :rural_status
      t.string :rural_status_label
      t.timestamps
    end
  end
end
