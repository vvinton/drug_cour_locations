class SearchItemLocation < ApplicationRecord
  belongs_to :search_item
  belongs_to :program_information
end
