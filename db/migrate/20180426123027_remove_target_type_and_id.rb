class RemoveTargetTypeAndId < ActiveRecord::Migration[5.1]
  def change
    remove_column :settings, :target_type, :string
    remove_column :settings, :target_id, :integer
  end
end
