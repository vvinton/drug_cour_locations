class RenameFirstNameOfJudge < ActiveRecord::Migration[5.1]
  def change
    rename_column :judge_informations, :firt_name, :first_name
  end
end
