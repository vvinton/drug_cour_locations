
class RecreateGeodatumJob < ApplicationJob
  queue_as :default
  def perform
    GeoDatum.delete_all
    ProgramInformation.find_each do |pi|
      if pi.lat && pi.long && pi.geodata && !pi.lat.nan? && !pi.long.nan?
        GeoDatum.create_from_program_information(pi)
      end
    end
    RecalculateZipMapJob.new.perform
  end
end
