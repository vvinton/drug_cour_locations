


RecalculateZipMap.new.call

class RecalculateZipMapJob < ApplicationJob
  queue_as :default
  def perform
    RecalculateZipMap.new.call
    ReindexAllJob.perform_async
  end
end
