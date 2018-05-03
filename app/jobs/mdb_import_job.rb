class MdbImportJob < ApplicationJob
  queue_as :default

  class DatabaseNotLoaded < StandardError; end

  # Removes leading and trailing [] from the program name.
  def clean_row_item(row_item)
    row_item = row_item.to_s.gsub(/\[|\]/, '')
    row_item = row_item.strip
    row_item
  rescue
    row_item
  end

  def get_temp_file
    file = Tempfile.new(@record.file.filename.to_s)
    file.binmode
    file.write(@record.file.blob.download)
    file.flush
    file.close
    file
  end

  def setup_database
    temp_file = get_temp_file
    @database = Mdb.open(temp_file.path)
  end

  def handle_program_information_import
    ProgramInformation.delete_all
    start_time = Time.now
    @database["Program Information"].each do |row|
      begin
        pi = ProgramInformation.new(program_name:        clean_row_item(row[:"Program Name"]),
                                    court_name:          clean_row_item(row[:"Court Name"]),
                                    operational_status:  clean_row_item(row[:"Operational Status"]),
                                    case_type:           row[:"Case Type"],
                                    implementation_date: row[:"Implementation Date"],
                                    program_type:        clean_row_item(row[:"Program Type"]),
                                    address:             row[:"Address"],
                                    city: clean_row_item(row[:"City"]),
                                    state: clean_row_item(row[:"State"]),
                                    zip_code: row[:"Zip Code"],
                                    phone_number: row[:"Phone Number"],
                                    email: row[:"E-mail"],
                                    website: row[:"Website"],
                                    notes: row[:"Notes"])
        if pi.save
          pi.update_location!(geofinder)
          @mapping[row[:"ID"]] = pi.id
          pi.save
        else
          raise "ERROR Saving imported Data"
        end
      rescue => e
        puts "ERROR ProgramInformation: #{e.message}"
        next
      end
    end
    puts "Program Information Import Took: #{Time.now - start_time}"
    true
  end

  def handle_state_coordinator_import
    CoordinatorInformation.delete_all
    @database["Coordinator Information"].each do |row|
      begin
        coordinator_info = CoordinatorInformation.new(program_information_id: @mapping[row[:"ProgramID"]],
                                                      current_contact: row[:"Current Contact"],
                                                      title: row[:"Title"],
                                                      first_name: row[:"Coordinator First Name"],
                                                      last_name: row[:"Coordinator Last Name"],
                                                      email: row[:"E-mail"],
                                                      phone: row[:"Phone"])
        coordinator_info.save
      rescue => e
        puts "ERROR COORDINATOR IMPORT: #{e.message}"
        next
      end
    end
  end

  def handle_state_coordinator_import
    StateCoordinator.delete_all
    @database['State Coordinators'].each do |row|
      begin
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
      rescue => e
        puts "ERROR StateCoordinator: #{e.message}"
        next
      end
    end
  end

  def perform(import_file_id)
    @record = Import.find import_file_id
    @mapping = {}
    @geofinder = CacheGeofind.new
    setup_database
    if @database
      handle_program_information_import
      handle_coordinator_information_import
      handle_state_coordinator_import
    else
      raise DatabaseNotLoaded.new "Unable to load or query imported database"
    end
  end
end
