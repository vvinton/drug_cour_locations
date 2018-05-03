class GrantImportJob < SpreadsheetImportJob
  def before_processing_point
    BjaGrant.delete_all
  end

  def spreadsheet_match_term
    grant_match_term
  end

  def spreadsheet_description
    'Grant Type'
  end

  def handle_row(hash_row)
    BjaGrant.create(hash_row)
  end

  def header_to_attribute
    hsh = Hash.new
    hsh['Fiscal Year']          = 'fiscal_year'
    hsh['Program Office']       = 'program_office'
    hsh['State']                = 'state'
    hsh['Grantee']              = 'grantee'
    hsh['Solicitation Title']   = 'solicitation_title'
    hsh['Award Number']         = 'award_number'
    hsh['GMS Award Status']     = 'gms_award_status'
    hsh['FMIS2 Award Status']   = 'fmis2_award_status'
    hsh['Award Date']           = 'award_date'
    hsh['Project Period Start'] = 'project_period_start'
    hsh['Project Period End']   = 'project_period_end'
    hsh['Grant Mgr Last']       = 'grant_mgr_last'
    hsh['Grant Mgr First']      = 'grant_mgr_first'
    hsh['Project Title']        = 'project_title'
    hsh['POC Name']             = 'poc_name'
    hsh['POC Email']            = 'poc_email'
    hsh['FPOC Name']            = 'fpoc_name'
    hsh['FPOC Email']           = 'fpoc_email'
    hsh['GMS FPOC Name']        = 'gms_fpoc_name'
    hsh['GMS FPOC Email']       = 'gms_fpoc_email'
    hsh['Tribal']               = 'tribal'
    hsh
  end
end
