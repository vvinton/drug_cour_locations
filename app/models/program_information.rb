class ProgramInformation < ApplicationRecord
  include ProgramInformationAggregations
  has_many :judge_informaion
  has_many :jurisdiction_information
  has_many :coordinator_information
  has_many :grant_information
  has_one :state_coordinator, foreign_key: 'state', primary_key: 'state'

  accepts_nested_attributes_for :coordinator_information

  class << self
    def searchable_fields
      %i(address state program_type program_name
         email phone_number county contact_name website)
    end
  end

  def city_state_zip
    [city, state, zip_code].delete_if {|x| x.blank? }.join(', ')
  end

  def search_data
    {
      address:      address,
      state:        state,
      program_type: program_type,
      program_name: program_name,
      email:        coordinator_information.first.try(:email),
      phone_number: coordinator_information.first.try(:phone),
      lat:          lat,
      long:         long,
      zip_code:     zip_area,
      county:       county,
      contact_name: coordinator_information.first.try(:full_name),
      coordinates:  geo_location,
      website:      website
    }
  end

  def geo_location
    { lat: lat.to_f, lon: long.to_f }
  end

  def zip_area
    (zip_code.to_i / 100).to_s
  end

  # The HexDigest of the address, city, and state.
  def marker
    Digest::SHA1.hexdigest(full_location)
  end

  def full_location
    "#{address}, #{city}, #{state}"
  end

  def geodatum_marker
    @geodatum_marker ||= GeoDatum.where(marker: marker).first
  end

  def update_location!(geofinder = CacheGeofind.new)
    if geodatum_marker
      self.geodata = geodatum_marker.data
      self.lat     = geodatum_marker.lat
      self.long    = geodatum_marker.lng
      if county_component = geodatum_marker.data['address_components'].detect{ |a| a['types'].include?('administrative_area_level_2') }
        self.county = county_component['long_name']
      end
      self.zip_code = GeoDatum.state_center[state.titleize] unless zip_code
    else
      data = geofinder.search(full_location)
      if data
        self.geodata = data
        self.lat     = data.dig('geometry', 'location', 'lat')
        self.long    = data.dig('geometry', 'location', 'lng')
        if county_component = data['address_components'].detect { |a| a['types'].include?('administrative_area_level_2') }
          self.county = county_component['long_name']
        end
        self.zip_code = GeoDatum.state_center[state.titleize] unless zip_code
        GeoDatum.create_from_program_information(self)
      end
    end
    save!
  end
end
