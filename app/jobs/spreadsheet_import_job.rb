class SpreadsheetImportJob < ApplicationJob
  queue_as :default

  def spreadsheet_match_term
    raise 'Must be defined in your child class'
  end

  def spreadsheet_description
    raise 'Must be defined in your child class'
  end

  def handle_row(hash_row)
    raise 'Must be defined in your child class'
  end

  def header_to_attribute
    raise 'Must be defined in your child class'
  end

  # Add logic that happens before we process the spreadsheet, like deleting
  # the entrie existing database
  def before_processing_point
    true
  end

  # Add logic that happens after we process the spreadsheet, like launching
  # intetgration data jobs, analytics reports, etc.
  def after_processing_point
    true
  end

  def sheet_name
    'Sheet1'
  end

  def perform(import_file_id)
    @record = Import.find import_file_id
    handle_incorrect_spreadsheet if not_correct_spreadsheet?(spreadsheet, spreadsheet_match_term)
    before_processing_point
    spreadsheet.each_with_pagename do |name, sheet|
      next unless name == sheet_name
      handle_sheet(sheet)
    end
    after_processing_point
  end

  # converts to a hash attribute list
  def convert_to_hash_row(sheet, row)
    hsh = Hash.new
    sheet.row(row).each_with_index do |cell, indx|
      hsh[@headers[indx]] = cell
    end
    hsh
  end

  def handle_sheet(sheet)
    setup_headers_index(sheet)
    ((sheet.first_row + 1)..sheet.last_row).each do |row|
      hash_row = convert_to_hash_row(sheet, row)
      handle_row(hash_row)
    end
  end

  def setup_headers_index(sheet)
    @headers = Hash.new
    sheet.row(1).each_with_index do |header, i|
      @headers[i] = header_to_attribute[header]
    end
    true
  end

  class IncorrectSpreadsheet  < StandardError; end
  class UnsupportedFileFormat < StandardError; end

  def spreadsheet
    @spreadsheet ||= get_spreadsheet
  end

  def get_spreadsheet
    Roo::Spreadsheet.open(@record.mdb.path)
  end

  def handle_incorrect_spreadsheet
    raise IncorrectSpreadsheet.new "The spreadsheet supplied was not a #{spreadsheet_description} spreadsheet"
  end

  def grant_match_term
    'Fiscal Year'
  end

  def program_information_match_term
    'ID'
  end

  def get_first_row_first_column
    spreadsheet.sheet(sheet_name).row(1)[0].to_s
  end

  def not_correct_spreadsheet?(spreadsheet, match_term)
    get_first_row_first_column != match_term rescue true
  end
end
