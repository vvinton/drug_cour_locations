class CreateJurisdictionNames < ActiveRecord::Migration[5.0]
  def change
    create_table :jurisdiction_names do |t|
      t.belongs_to :jurisdiction_information, index: true
      t.string :jurisdiction_name
      t.timestamps
    end
  end
end
