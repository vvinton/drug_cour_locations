class CreateJudgeInformaions < ActiveRecord::Migration[5.0]
  def change
    create_table :judge_informaions do |t|
      t.belongs_to :program_information, index: true
      t.string :last_name
      t.string :firt_name
      t.string :email
      t.string :title
      t.string :phone
      t.string :current_contact
      t.timestamps
    end
  end
end
