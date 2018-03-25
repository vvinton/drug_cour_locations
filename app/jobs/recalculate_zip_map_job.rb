
class RecalculateZipMapJob < ApplicationJob
  queue_as :default

  def perform
    RecalculateZipMap.new.call
    ReindexAllJob.new.perform
  end
end
