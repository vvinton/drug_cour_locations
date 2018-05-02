class RemoveWebsiteFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :state_coordinators, :website, :string
    remove_column :program_informations, :lat, :float
    remove_column :program_informations, :long, :float
    remove_column :program_informations, :geodata
    remove_column :program_informations, :website
  end
end
