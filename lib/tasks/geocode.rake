namespace :geocode do
  desc 'add search items based on zip code of program informations'
  task encode_zip: :environment do
    RecalculateZipMap.new.call
  end

  desc 'create a fixture for GeoDatum for the center of each state'
  task state_center: :environment do
    file = "#{Rails.root}/lib/csv/state_center.csv"
    state_center = {}
    CSV.foreach(file, headers: true) do |row|
      state_center[row[0]] = {lat: row[1].to_f, lng: row[2].to_f}
    end
    state_center['DC']                   = state_center['District of Columbia']
    state_center['District Of Columbia'] = state_center['District of Columbia']
    pp state_center
  end

  desc 'geocodes a location (pass city, state, zip into the full location)'
  task :location, [:full_location] => :environment do |_task, args|
    Geocoder.configure(:timeout => 30, api_key: 'AIzaSyCyqgWP9c3hM-sdIfmBWxZTzAWYqfJCQrA')
    resp = Geocoder.search(args.full_location)
    pp resp
  end
end
