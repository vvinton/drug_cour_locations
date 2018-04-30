class ProgramInformationSpreadsheetImportJob < SpreadsheetImportJob
  def header_to_attribute
    hsh = Hash.new
    hsh['ID']                                   = 'id'
    hsh['Program Name']                         = 'program_name'
    hsh['Court Name']                           = 'court_name'
    hsh['Operational Status']                   = 'operational_status'
    hsh['Case Type']                            = 'case_type'
    hsh['Implementation Date']                  = 'implementation_date'
    hsh['Program Type']                         = 'program_type'
    hsh['Address']                              = 'address'
    hsh['City']                                 = 'city'
    hsh['State']                                = 'state'
    hsh['Zip Code']                             = 'zip_code'
    hsh['Phone Number']                         = 'phone_number'
    hsh['Website']                              = 'website'
    hsh['Notes']                                = 'notes'
    hsh['Program Add Date']                     = 'program_add_date'
    hsh['Coordinator Information Last Name']    = 'coordinator_last_name'
    hsh['Coordinator Information First Name']   = 'coordinator_first_name'
    hsh['Coordinator Information Email']        = 'coordinator_email'
    hsh['Coordinator Information Title']        = 'coordinator_title'
    hsh['Coordinator Information Phone Number'] = 'coordinator_phone'
    hsh['Judge Information Last Name']          = 'judge_last_name'
    hsh['Judge Information First Name']         = 'judge_first_name'
    hsh['Judge Information Email']              = 'judge_email'
    hsh['Judge Information Title']              = 'judge_title'
    hsh['Judge Information Phone Number']       = 'judge_phone'
    hsh
  end

  def spreadsheet_match_term
    program_information_match_term
  end

  def spreadsheet_description
    'Program Information'
  end

  def after_processing_point
    Rails.cache.clear
  end

  def handle_row(hash_row)
    program     = set_program_information(hash_row)
    coordinator = set_coordinator_information(program, hash_row)
    judge       = set_judge_information(program, hash_row)
    program = nil
    coordinator = nil
    judge = nil
  end

  def set_program_information(hash_row)
    program = ProgramInformation.where(id: hash_row['id']).limit(1)&.first
    program = ProgramInformation.new(id: hash_row['id'].to_i) if program.nil?
    program.update_attributes(program_from_hash_row(hash_row))
    program
  end

  def set_coordinator_information(program, hash_row)
    if has_coordinator_information?(hash_row)
      coordinator = program.coordinator_information.limit(1)&.first
      coordinator = program.coordinator_information.new if coordinator.nil?
      coordinator.update_attributes(coordinator_from_hash_row(hash_row))
      coordinator
    else
      program.coordinator_information.delete_all
      nil
    end
  end

  def set_judge_information(program, hash_row)
    if has_judge_information?(hash_row)
      judge = program.judge_information.limit(1)&.first
      judge = program.judge_information.new if judge.nil?
      judge.update_attributes(judge_from_hash_row(hash_row))
      judge
    else
      program.judge_information.delete_all
      nil
    end
  end

  def program_from_hash_row(hash_row)
    hash_row.slice(*program_attribute_fields)
  end

  def program_attribute_fields
    %w[ program_name court_name operational_status case_type implmentation_date
        program_type address city state zip_code phone_number program_add_date
        notes ]
  end

  def coordinator_from_hash_row(hash_row)
    hsh = hash_row.slice(*coordinator_attribute_fields)
    hsh.each_key do |key|
      hsh[key.gsub('coordinator_', '')] = hsh[key]
      hsh.delete(key)
    end
    hsh['current_contact'] = true
    hsh
  end

  def coordinator_attribute_fields
    %w[coordinator_last_name coordinator_first_name coordinator_title coordinator_phone coordinator_email]
  end

  def has_coordinator_information?(hash_row)
    !hash_row['coordinator_last_name'].blank?
  end

  def judge_from_hash_row(hash_row)
    hsh = hash_row.slice(*judge_attribute_fields)
    hsh.each_key do |key|
      hsh[key.gsub('judge_', '')] = hsh[key]
      hsh.delete(key)
    end
    hsh['current_contact'] = true
    hsh
  end

  def judge_attribute_fields
    %w[judge_last_name judge_first_name judge_title judge_phone judge_email]
  end

  def has_judge_information?(hash_row)
    !hash_row['judge_last_name'].blank?
  end
end
