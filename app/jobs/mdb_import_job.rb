class MdbImportJob < ApplicationJob
  queue_as :default

  def perform(import_file_id)
    import_file = Import.find import_file_id
    mapping = {}
    database = Mdb.open(import_file.mdb.path)
    ProgramInformation.delete_all
    database["Program Information"].each do |row|
      pi = ProgramInformation.new(  program_name: row[:"Program Name"],
                                    court_name: row[:"Court Name"],
                                    operational_status: row[:"Operational Status"],
                                    case_type: row[:"Case Type"],
                                    implementation_date: row[:"Implementation Date"],
                                    program_type: row[:"Program Type"],
                                    address: row[:"Address"],
                                    city: row[:"City"],
                                    state: row[:"State"],
                                    zip_code: row[:"Zip Code"],
                                    phone_number: row[:"Phone Number"],
                                    email: row[:"E-mail"],
                                    website: row[:"Website"],
                                    notes: row[:"Notes"]
                                  )
      pi.save
      pi.update_location!
      mapping[row[:"ID"]] = pi.id
    end
    CoordinatorInformation.delete_all
    database["Coordinator Information"].each do |row|
      coordinator_info = CoordinatorInformation.new( program_information_id: mapping[row[:"ProgramID"]],
                                                    current_contact: row[:"Current Contact"],
                                                    title: row[:"Title"],
                                                    first_name: row[:"Coordinator First Name"],
                                                    last_name: row[:"Coordinator Last Name"],
                                                    email: row[:"E-mail"],
                                                    phone: row[:"Phone"]
                                                  )
      coordinator_info.save
    end
    ProgramInformation.where(lat: nil).delete_all
    ProgramInformation.reindex
  end
end
