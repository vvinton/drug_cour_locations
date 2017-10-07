class SearchItemLocation < ApplicationRecord
  belongs_to :search_item
  belongs_to :program_information

  class << self
    # used in the Rake task to reindex items
    def find_or_create_location(search_location, program_information)
      sil = nil
      sil = where(search_item_id: search_location.id,
                  program_information_id: program_information.id).limit(1)
                                                                 .try(:first)
      unless sil
        sil = new
        sil.search_item_id = search_location.id
        sil.program_information_id = program_information.id
        sil.save
      end
      sil
    end
  end
end
