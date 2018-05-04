class StateCoordinatorImportJob < SpreadsheetImportJob
  def before_processing_point
    StateCoordinator.delete_all
  end

  def spreadsheet_match_term
    state_coordinator_match_term
  end

  def spreadsheet_description
    'State Coordinator'
  end

  def handle_row(hash_row)
    puts "PUTTING #{hash_row}"
    resp = StateCoordinator.new(hash_row)
    puts "#{resp.errors}" unless resp.save
  end

  def header_to_attribute
    hsh = Hash.new
    hsh['State']          = 'state'
    hsh['First Name']     = 'first_name'
    hsh['Last Name']      = 'last_name'
    hsh['Agency']         = 'agency'
    hsh['Title']          = 'title'
    hsh['Address']        = 'address'
    hsh['City']           = 'city'
    hsh['Zip']            = 'zip'
    hsh['Phone Number']   = 'phone'
    hsh['Email']          = 'email'
    hsh
  end
end
