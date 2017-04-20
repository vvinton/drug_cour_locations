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
end
