class GeoDatum < ApplicationRecord

  ZIP_CODES = {
    "Massachusetts" => "01300",
    "Arkansas" => "71700",
    "Alabama" => "35400",
    "South Carolina" => "29500",
    "California" => "91000"
  }

  def self.create_from_program_information(pi)
    create(
      marker: pi.marker,
      lat: pi.lat,
      lng: pi.long,
      data: pi.geodata
    )
  end
end
