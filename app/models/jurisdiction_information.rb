class JurisdictionInformation < ApplicationRecord
  belongs_to :program_information
  has_one    :jurisdiction_name
end
