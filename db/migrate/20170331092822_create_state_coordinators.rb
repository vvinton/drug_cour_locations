class CreateStateCoordinators < ActiveRecord::Migration[5.0]
  def change
    create_table :state_coordinators do |t|
      t.string :current_contact
      t.string :last_name
      t.string :firt_name
      t.string :email
      t.string :title
      t.string :phone
      t.string :address
      t.string :agency
      t.string :zip
      t.string :website
      t.timestamps
    end
  end
end
