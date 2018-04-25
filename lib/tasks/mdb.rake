require 'csv'
require 'mdb'
require 'moneta'
require 'csv'

namespace :setup_app do
  desc 'reindex'
  task :reindex, [:file_path] => :environment do |_task, args|
    ProgramInformation.reindex
  end
end


namespace :mdb do
  desc 'import an MDB file and perform all actions'
  task :import,  [:file_path] => :environment do |_task, args|
    import = Import.new
    file = File.open("#{Rails.root}/lib/csv/mdb_db.mdb")
    import.mdb = file
    import.save
    helper = MdbImportJob.new
    puts "Starting performing Job"
    helper.perform(import.id)
  end

  desc 'export to CSV all tables'
  task :export_to_csv, [:file_path] => :environment do |_task, args|
    database = Mdb.open(args.file_path)
    export_time = Time.now.strftime('%Y%m%d%H%S')
    database.tables.each do |table_name|
      encoded_table_name = CGI.escape(table_name)
      file_name = "#{Rails.root}/tmp/#{encoded_table_name}_#{export_time}.csv"
      header_record = database[table_name].first
      if header_record
        puts "Exporting: #{table_name} to #{file_name}"
        CSV.open(file_name, "wb") do |csv|
          header_record = database[table_name].first
          csv << header_record.keys
          database[table_name].each do |row|
            csv << row.values
          end
        end
      else
        puts "SKIP #{table_name} has no records."
      end
    end
  end

  desc 'prints a supplied MDB file'
  task :read, [:file_path] => :environment do |_task, args|
    database = Mdb.open(args.file_path)

    database['Program Information'].each do |row|
      puts row.inspect
    end
  end

  desc 'unique addresses count for Program Infomation'
  task :unique_addresses, [:file_path] => :environment do |_task, args|
    database = Mdb.open(args.file_path)
    pua = {}
    skipped_count = 0
    database['Program Information'].each do |row|
      full_address = "#{row[:'Address']}, #{row[:'City']}, #{row[:'State']}"
      if row[:'Address'].nil? || row[:'City'].nil? || row[:'State'].nil?
        skipped_count += 1
        puts "SKIPPED: #{full_address} ROW: #{row.inspect}"
      else
        pua[full_address] = [] if pua[full_address].nil?
        pua[full_address] << row
        puts "OK: #{full_address}"
      end
    end
    puts "Skipped Count: #{skipped_count}"
    puts "Unique Locations: #{pua.keys.length}"
  end

  desc 'update GeoQuery cache fixture'
  task :update_geoquery_fixture, [:file_path] => :environment do |_task, args|
    begin
      geofinder = CacheGeofind.new
      database = Mdb.open(args.file_path)
      skipped_count = 0
      jq_array = []
      pua = {}
      cache_fixture_path = "#{Rails.root}/lib/csv/geoquery_cache.json"
      database['Program Information'].each do |row|
        full_address = "#{row[:'Address']}, #{row[:'City']}, #{row[:'State']}"
        full_address = AddressCleaner.clean(full_address)
        if row[:'Address'].nil? || row[:'City'].nil? || row[:'State'].nil?
          skipped_count += 1
          puts "SKIPPED: #{full_address}"
        else
          pua[full_address] = 0 if pua[full_address].nil?
          pua[full_address] += 1
        end
      end
      puts "Import complete: Skipped: #{skipped_count}. Geocoding..."
      pua.keys.each do |key|
        resp = geofinder.search(key)
        unless resp
          puts "WARN: NoMatchedResponse key:|#{key}|"
        end
      end
      geofinder.write_cache_fixture
      geofinder.write_unencodable_list
      puts "DONE: Skipped Count: #{skipped_count}"
    ensure
      geofinder.store.close
    end
  end
end
