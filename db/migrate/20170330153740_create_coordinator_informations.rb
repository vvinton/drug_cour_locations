class CreateCoordinatorInformations < ActiveRecord::Migration[5.0]
  def change
    create_table :coordinator_informations do |t|
      t.belongs_to :program_information, index: true
      t.string  :current_contact
      t.string  :title
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.string  :phone

      t.timestamps
    end
  end
end
