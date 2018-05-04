class SyncGoogleSpreadsheetJob < ApplicationJob
  queue_as :default
  delegate :worksheet_rows, :spreadsheet_id, to: :google_spreadsheet

  # Error classes
  class InvalidConfig < StandardError; end
  class BadDownload   < StandardError; end

  def perform
    if validated_confg

    end
  rescue => e
    puts "RAISE #{e.message}"
    raise e
  end

  def google_spreadsheet
    @google_spreadsheet ||= GoogleSpreadsheet.new
  end

  def validated_config
    raise_bad_config if !valid_job_config?
    raise_bad_download if !valid_download?
    true
  end

  def valid_job_config?
    !spreadsheet_id.blank?
  end

  def valid_download?
    Array(worksheet_rows).length > 0
  end

  def raise_bad_config
    raise InvalidConfig.new "Configuration file is invalid. Bad job config?"
  end

  def raise_bad_download
    raise BadDownload.new "Unable to retrieve Google Spreedsheet. Check OAuth config."
  end
end
