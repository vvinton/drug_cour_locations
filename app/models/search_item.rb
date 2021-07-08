class SearchItem < ApplicationRecord
  has_many :search_item_locations
  has_many :program_informations, through: :search_item_locations

  searchkick

  def search_data
    {
      lat: lat,
      lng: lng,
      short_name: short_name
    }
  end

  class << self
    def find_or_create_from_program_information(pi)
      si = where(full_name: pi.zip_code).try(:first)
      unless si
        si = new
        si.lat = pi.lat
        si.lng = pi.long
        si.short_name = zip_code_to_short_name(pi.zip_code)
        si.hint = "zip_code"
        si.full_name = pi.zip_code
        si.save
      end
      si
    end

    def zip_code_to_short_name(zip)
      zip.to_s.slice(0,2)
    end
  end
end
