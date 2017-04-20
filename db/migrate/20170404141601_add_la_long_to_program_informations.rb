class AddLaLongToProgramInformations < ActiveRecord::Migration[5.0]
  def change
    add_column :program_informations, :lat, :float
    add_column :program_informations, :long, :float
    add_column :program_informations, :geodata, :jsonb
  end
end
