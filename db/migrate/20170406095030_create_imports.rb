class CreateImports < ActiveRecord::Migration[5.0]
  def change
    create_table :imports do |t|
      t.attachment :mdb
      t.timestamps
    end
  end
end
