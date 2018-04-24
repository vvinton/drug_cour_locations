class RenameFirstNameOnCoordinators < ActiveRecord::Migration[5.0]
  def change
    rename_column :state_coordinators, :firt_name, :first_name
  end
end
