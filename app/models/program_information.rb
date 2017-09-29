class ProgramInformation < ApplicationRecord
  include ProgramInformationAggregations
  has_many :judge_informaion
  has_many :jurisdiction_information
  has_many :coordinator_information
  has_many :grant_information
  has_one :state_coordinator, foreign_key: 'state', primary_key: 'state'

  accepts_nested_attributes_for :coordinator_information

  searchkick word_start: ['address'], merge_mappings: true, mappings: PROGRAM_MAPPING

  def search_data
    {
      address: address,
      state: state,
      program_type: program_type,
      program_name: program_name,
      email: coordinator_information.first.try(:email),
      phone_number: coordinator_information.first.try(:phone),
      lat: lat,
      long: long,
      zip_code: zip_area,
      county: county,
      contact_name: coordinator_information.first.try(:full_name),
      coordinates: geo_location,
      website: website
    }
  end

  def geo_location
    { lat: lat.to_f, lon: long.to_f }
  end

  def zip_area
    (zip_code.to_i / 100).to_s
  end

  def marker
    Digest::SHA1.hexdigest(full_location)
  end

  def full_location
    "#{address}, #{city}, #{state}"
  end

  def update_location!
    if data = GeoDatum.where(marker: marker).first
      self.geodata = data.data
      self.lat = data.lat
      self.long = data.lng
      if county_component = data.data["address_components"].detect{ |a| a["types"].include?("administrative_area_level_2") }
        self.county = county_component["long_name"]
      end
      self.zip_code = GeoDatum::ZIP_CODES[state] unless zip_code
    else
      res = Geocoder.search(full_location)
      if res.last
        self.geodata = res.last.data
        self.lat = res.last.data["geometry"]["location"]["lat"]
        self.long = res.last.data["geometry"]["location"]["lng"]
        if county_component = res.last.data["address_components"].detect{ |a| a["types"].include?("administrative_area_level_2") }
          self.county = county_component["long_name"]
        end
        self.zip_code = GeoDatum::ZIP_CODES[state] unless zip_code
        GeoDatum.create_from_program_information(self)
      end
    end
    save!
  end
end
