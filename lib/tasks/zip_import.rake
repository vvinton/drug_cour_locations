require 'csv'
namespace :import do

  # "zip_code","latitude","longitude","city","state","county"
  desc 'imports the zip code database'
  task :zip => :environment do
    file = "#{Rails.root}/lib/csv/zip_code_database.csv"
    CSV.foreach(file, headers: true) do |row|
      puts "Importing #{row['zip_code']}"
      zip = Zipdb.new(
        zip:    row['zip_code'].to_i,
        lng:    row['longitude'].to_f,
        lat:    row['latitude'].to_f,
        city:   row['city'],
        state:  row['state'],
        county: row['county']
      )
      zip.save
    end
  end
end

namespace :destroy do
  desc 'removes all the data from the zip code database'
  task :zip => :environment do
    Zipdb.destroy_all
  end
end
