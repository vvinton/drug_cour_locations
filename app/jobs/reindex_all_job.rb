class ReindexAllJob < ApplicationJob
  queue_as :default

  def perform
    # ProgramInformation.reindex
    # SearchItem.reindex
  end
end
