class CreateGeoData < ActiveRecord::Migration[5.0]
  def change
    create_table :geo_data do |t|
      t.jsonb :data
      t.float :lat
      t.float :lng
      t.string :marker

      t.timestamps
    end
    ProgramInformation.find_each do |pi|
      if pi.lat && pi.long && pi.geodata && !pi.lat.nan? && !pi.long.nan?
        GeoDatum.create_from_program_information(pi)
      end
    end
  end
end
