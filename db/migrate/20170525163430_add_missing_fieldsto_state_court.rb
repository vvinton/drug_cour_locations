class AddMissingFieldstoStateCourt < ActiveRecord::Migration[5.0]
  def change
    add_column :state_coordinators, :state, :string
    add_column :state_coordinators, :city, :string
  end
end
