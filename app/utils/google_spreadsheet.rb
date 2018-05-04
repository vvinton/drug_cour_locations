require 'google_drive'
require 'json'
require 'retryable'

class GoogleSpreadsheet
  attr_accessor :args

  def initialize(args = {})
    @args = args
    @staged_changes = []
    @staging_errors = []
    @commit_errors = []
  end

  # retrieves the spreadsheet id from the arguments, or the Global settings
  def spreadsheet_id
    @spreadsheet_id ||= begin
      s_id = args.dig(:spreadsheet_id)
      s_id = Settings.spreadsheet_id if s_id.nil?
      s_id = '1DArhpCvq2crv4Ki8NiNnpfiypO287kClZLfPpTqB3F4' if s_id.nil?
      s_id
    end
  end

  # retrieves the worksheet_index from the arguments, or the Global settings
  def worksheet_index
    @worksheet_index ||= begin
      w_ix = args.dig(:worksheet_index)
      w_ix = Settings.worksheet_index if w_ix.nil?
      w_ix = 0 if w_ix.nil?
      w_ix
    end
  end

  def get_row_by_index(row_index)
    rows[row_index]
  end

  def rows
    @rows ||= worksheet.rows
  end

  def headers
    @headers ||= worksheet.rows[0]
  end

  def worksheet_rows
    @worksheet_rows ||= begin
      puts "Caching #{spreadsheet_id}... this can take a few minutes depending on the size of the spreadsheet."
      wh = []
      worksheet.rows.each_with_index do |row, indx|
        next if indx == 0
        worksheet_row = indx + 1
        hsh = {}
        hsh['row_index'] = worksheet_row
        row.each_with_index do |column, c_indx|
          hsh[headers[c_indx]] = column
        end
        wh << hsh
      end
      wh
    end
  end

  def worksheet
    @worksheet ||= workbook.worksheets[worksheet_index]
  end

  def config_path
    File.expand_path('../../config/config.json', File.dirname(__FILE__))
  end

  def workbook
    @workbook ||= session.spreadsheet_by_key(spreadsheet_id)
  end

  def session
    @session ||= GoogleDrive::Session.from_config(config_path)
  end
end
