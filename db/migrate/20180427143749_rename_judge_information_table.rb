class RenameJudgeInformationTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :judge_informaions, :judge_informations
  end
end
