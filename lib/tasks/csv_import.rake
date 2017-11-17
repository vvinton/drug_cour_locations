require 'csv'
namespace :import do

  desc 'recreate search locations'
  task :search_locations => :environment do
    ProgramInformation.find_each do |pi|
      if pi.lat && pi.long && pi.geodata && !pi.lat.nan? && !pi.long.nan? && pi.zip_code
        search_item = SearchItem.find_or_create_from_program_information(pi)
        search_item_location = SearchItemLocation.find_or_create_location(search_item, pi) if search_item
        puts "PI: #{pi.id} - #{pi.zip_code} SI:#{search_item.id} SIL: #{search_item_location.id}"
      end
    end
    puts "Reindexing SearchItem"
    SearchItem.reindex
  end

  desc 'recreate geodatum'
  task :geodatum => :environment do
    RecreateGeodatumJob.new.perform
  end

  desc 'drop irrelevant data'
  task :drop_broken => :environment do
    ProgramInformation.where(lat: nil).delete_all
  end

  desc 'truncate data for reimport'
  task :drop_everything => :environment do
    User.delete_all
    Role.delete_all
    SearchItem.delete_all
    SearchItemLocation.delete_all
    ProgramInformation.delete_all
    CoordinatorInformation.delete_all
  end

  desc 'import coordinator_information data from csv files'
  task :coordinator_information => :environment do
    file = "#{Rails.root}/lib/csv/Coordinator_Information.csv"
    CSV.foreach(file, headers: true) do |row|
      CoordinatorInfo = CoordinatorInformation.new( program_information_id: row["ProgramID"].to_i,
                                                    current_contact: row["Current Contact"],
                                                    title: row["Title"],
                                                    first_name: row["Coordinator First Name"],
                                                    last_name: row["Coordinator Last Name"],
                                                    email: row["E-mail"],
                                                    phone: row["Phone"]
                                                  )
      CoordinatorInfo.save
    end
  end

  desc 'import program_information data from csv files'
  task :program_information => :environment do
    file = "#{Rails.root}/lib/csv/Program_Information.csv"
    CSV.foreach(file, headers: true) do |row|
      pi = ProgramInformation.new( id: row["ID"].to_i,
                                            program_name: row["Program Name"],
                                            court_name: row["Court Name"],
                                            operational_status: row["Operational Status"],
                                            case_type: row["Case Type"],
                                            implementation_date: row["Implementation Date"],
                                            program_type: row["Program Type"],
                                            address: row["Address"],
                                            city: row["City"],
                                            state: row["State"],
                                            zip_code: row["Zip Code"],
                                            phone_number: row["Phone Number"],
                                            email: row["E-mail"],
                                            website: row["Website"],
                                            notes: row["Notes"]
                                          )
      pi.save
      res = Geocoder.search("#{pi.address}, #{pi.city}, #{pi.state}")
      if res.last
        pi.geodata = res.last.data
        pi.lat = res.last.data["geometry"]["location"]["lat"]
        pi.long = res.last.data["geometry"]["location"]["lng"]
        pi.save
      end
    end
  end
end
