namespace :geocode do 
  desc 'add search items based on zip code of program informations'
  task encode_zip: :environment do
    ProgramInformation.pluck(:zip_code).uniq.group_by{|zip| zip.to_i / 100 }.each do |name, zip_codes|
      search_item = SearchItem.new(short_name: name.to_s, hint: 'zip_code')
      geocode_info = []
      zip_codes.each do |zip| 
        ProgramInformation.where(zip_code: zip).each do |pi|
          if pi.lat && pi.long
            geocode_info << [pi.lat, pi.long] 
            search_item.program_informations << pi
          end
        end
      end
      res = Geocoder::Calculations.geographic_center(
        geocode_info
      )
      if !res[0].nan? && !res[1].nan? && search_item.short_name != '0'
        search_item.lat = res[0]
        search_item.lng = res[1]
        search_item.full_name = zip_codes.join(', ')
        search_item.save!
      end
    end
  end
end
