class AddCountyToProgramInformations < ActiveRecord::Migration[5.0]
  def change
    add_column :program_informations, :county, :string
  end
end
