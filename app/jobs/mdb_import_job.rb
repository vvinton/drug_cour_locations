class MdbImportJob < ApplicationJob
  queue_as :default

  # Removes leading and trailing [] from the program name.
  def clean_row_item(row_item)
    row_item = row_item.to_s.gsub(/\[|\]/, '')
    row_item = row_item.strip
    row_item
  rescue
    row_item
  end

  def perform(import_file_id)
    import_file = Import.find import_file_id
    mapping = {}
    database = Mdb.open(import_file.mdb.path)
    ProgramInformation.delete_all
    database["Program Information"].each do |row|
      pi = ProgramInformation.new(  program_name: clean_row_item(row[:"Program Name"]),
                                    court_name: clean_row_item(row[:"Court Name"]),
                                    operational_status: clean_row_item(row[:"Operational Status"]),
                                    case_type: row[:"Case Type"],
                                    implementation_date: row[:"Implementation Date"],
                                    program_type: clean_row_item(row[:"Program Type"]),
                                    address: row[:"Address"],
                                    city: clean_row_item(row[:"City"]),
                                    state: clean_row_item(row[:"State"]),
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

    # Coordinator Infomration
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

    StateCoordinator.delete_all
    database['State Coordinators'].each do |row|
      sc_info = StateCoordinator.new(
          current_contact: row[:"Current Contact?"],
          last_name: row[:"LastName"],
          agency: row[:"Agency"],
          first_name: row[:"FirstName"],
          email: row[:"E-mail"],
          title: row[:"Title"],
          phone: row[:"Phone Number"],
          website: row[:"Website"],
          address: row[:"Address"],
          city: row[:"City"],
          state: row[:"State"],
          zip: row[:"Zip"])
      sc_info.save
    end
  end
end
