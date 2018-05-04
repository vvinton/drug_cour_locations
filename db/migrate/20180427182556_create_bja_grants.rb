class CreateBjaGrants < ActiveRecord::Migration[5.1]
  def change
    create_table :bja_grants do |t|
      t.integer :fiscal_year
      t.string :program_office
      t.string :state
      t.string :grantee
      t.string :solicitation_title
      t.string :award_number
      t.string :gms_award_status
      t.string :fmis2_award_status
      t.datetime :award_date
      t.datetime :project_period_start
      t.datetime :project_period_end
      t.string :grant_mgr_last
      t.string :grant_mgr_first
      t.string :project_title
      t.string :poc_name
      t.string :poc_email
      t.string :fpoc_name
      t.string :fpoc_email
      t.string :gms_fpoc_name
      t.string :gms_fpoc_email
      t.string :tribal

      t.timestamps
    end
  end
end
