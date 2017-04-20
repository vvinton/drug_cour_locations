class CreateProgramInformations < ActiveRecord::Migration[5.0]
  def change
    create_table :program_informations do |t|
      t.string :program_name
      t.string :court_name
      t.string :operational_status
      t.string :case_type
      t.string :implementation_date
      t.string :program_type
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :phone_number
      t.string :email
      t.string :website
      t.string :notes
      t.string :program_add_date
      t.timestamps
    end
  end
end
