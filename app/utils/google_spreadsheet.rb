require 'google_drive'
require 'json'
require 'retryable'

class GoogleSpreadsheet
  attr_accessor :worksheet_index, :spreadsheet_id, :staged_changes, :staging_errors, :commit_errors

  def initialize(spreadsheet_id = nil, worksheet_index = 0)
    @spreadsheet_id = spreadsheet_id
    @worksheet_index = worksheet_index
    @staged_changes = []
    @staging_errors = []
    @commit_errors = []
  end

  def refresh_worksheet
    write_changes_to_spreadsheet if worksheet.dirty?
  end

  def next_row_id
    last_row_id + 1
  end

  def last_row_id
    refresh_worksheet
    worksheet.num_rows
  end

  def staged_changes_count
    @staged_changes.count
  end

  def commit_staged_changes
    @staged_changes.each do |change|
      handle_change(change)
    end
    # write_changes_to_spreadsheet
    @staged_changes = []
  end

  def write_changes_to_spreadsheet
    puts "INFO: Writing to spreadsheet"
    worksheet.save
    worksheet.reload
  end

  # calls the right command passing the right config to that command to
  # execute the change (changes are not saved until you type worksheet.save)
  def handle_change(hsh)
    case hsh['action']
    when 'put_attribute'
      put_row_attribute(hsh['row_index'], hsh['column_name'], hsh['column_value'])
    when 'put_row'
      put_row_array(hsh['row_index'], hsh['row'])
    when 'put_hash'
      put_row_hash(hsh['row_index'], hsh['row_hash'])
    when 'copy_attribute'
      copy_row_attribute(hsh['row_index'], hsh['from'], hsh['to'])
    when 'move_attribute'
      move_row_attribute(hsh['row_index'], hsh['from'], hsh['to'])
    when 'clear_attribute'
      clear_row_attribute(hsh['row_index'], hsh['column_name'])
    when 'add_attribute'
      add_to_row_attribute(hsh['row_index'], hsh['column_name'], hsh['column_value'])
    when 'update_with_hash'
      update_row_with_hash(hsh['row_index'], hsh['row_hash'])
    when 'add_row'
      add_row(hsh['row'])
    when 'add_row_with_hash'
      add_row_with_hash(hsh['row_hash'])
    else
      puts "ERROR: Invalid action for hash #{hsh}"
      @commit_errors << {:action => hsh, :error => 'invalid action'}
    end
  end

  # indx, action, attr1, attr2, attr3, attr4
  # writes them to a folder, but does not write until you call the
  # commit
  def add_staged_change(*attrs)
    hsh = build_row_index(attrs)
    hsh = build_action(hsh, attrs)
    hsh = build_supplemental_configuration(hsh, attrs)
    @staged_changes << hsh if hsh['valid']
    if hsh['valid'] == false
      puts "ERROR: Staged Change Request not valid: #{hsh}"
      @staging_errors << hsh
    end
    true
  end

  def build_row_index(attrs)
    {'row_index' => attrs[0] }
  end

  def build_action(hsh, attrs)
   hsh = hsh.merge( {'action' => attrs[1] })
   hsh
  end

  # based on the action, the method adds the appropriate fields in the right
  # order to do the work.
  def build_supplemental_configuration(hsh, attrs)
    case hsh['action']
    when 'put_attribute'
      hsh = hsh.merge( {'column_name' => attrs[2], 'column_value' => attrs[3], 'valid' => true})
    when 'put_row'
      hsh = hsh.merge( { 'row' => attrs[2], 'valid' => true})
    when 'put_hash'
      hsh = hsh.merge({ 'row_hash' => attrs[2], 'valid' => true })
    when 'copy_attribute'
      hsh = hsh.merge({'from' => attrs[2], 'to' => attrs[3], 'valid' => true})
    when 'move_attribute'
      hsh = hsh.merge({'from' => attrs[2], 'to' => attrs[3], 'valid' => true})
    when 'clear_attribute'
      hsh = hsh.merge({'column_name' => attrs[2], 'valid' => true})
    when 'add_attribute'
      hsh = hsh.merge({'column_name' => attrs[2], 'column_value' => attrs[3], 'valid' => true})
    when 'update_with_hash'
      hsh = hsh.merge({'row_hash' => attrs[2], 'valid' => true})
    when 'add_row_with_hash'
      hsh = hsh.merge({'row_hash' => attrs[2], 'valid' => true})
    when 'add_row'
      hsh = hsh.merge({'row' => attrs[2], 'valid' => true})
    else
      hsh = hsh.merge({'valid' => false})
    end
    hsh
  end

  def clear_staged_changes!
    @staged_changes = []
  end

  def spreadsheet_id
    @spreadsheet_id ||= '133yovgCs1DI8mAzaCsDx0t2ZQ5dW-n90bN2QrKqJbgA'
  end

  def write_headers_to_spreadsheet(headers)
    put_row_array(1, headers)
  end

  def get_row_by_index(row_index)
    rows[row_index]
  end

  def rows
    @rows ||= worksheet.rows
  end

  # if we have a header matching this name, add 1 to it, because Google
  # sheets first column is column 1, not column 0.
  def column_index(term)
    resp = header_index(term)
    resp += 1 if resp
    resp
  end

  # get the ruby array (base 0) value for which column matches the header
  def header_index(term)
    resp = worksheet.rows.first.index(term)
    resp = resp if resp
    resp
  end

  def headers
    @headers ||= worksheet.rows[0]
  end

  def worksheet_hash
    @worksheet_hash ||= begin
      puts "Caching #{spreadsheet_id}... please wait a few seconds."
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

  def get_row_attribute(row_indx, column_name)
    worksheet[row_indx, column_index(column_name)]
  end

  # add_staged_change(indx, put_attribute, column_name, value)
  def put_row_attribute(row_indx, column_name, value)
    worksheet[row_indx, column_index(column_name)] = value
  end

  # add_staged_change(indx, put_all, row_array)
  def put_row_array(row_indx, arr)
    arr.each_with_index do |item, indx|
      sp_index = indx + 1
      worksheet[row_indx, sp_index] = item
    end
  end

  # add_staged_change(indx, put_all, hash)
  # this will OVERRWITE the row
  def put_row_hash(row_indx, hsh)
    arr = hash_to_row(hsh)
    put_row_array(row_indx, arr)
  end

  # add_staged_change(indx, update_row_with_hash, hash)
  # this will OVERRWITE ONLY the attributes in the hash
  def update_row_with_hash(row_indx, hsh)
    hsh.keys.each do |column_name|
      put_row_attribute(row_indx, column_name, hsh[column_name])
    end
  end

  # add_staged_change(indx, copy_attribute, from_column, to_column)
  def copy_row_attribute(row_indx, from_column, to_column)
    the_value = worksheet[row_indx, column_index(from_column)]
    put_row_attribute(row_indx, column_index(to_column), the_value)
  end

  # add_staged_change(indx, move_attribute, from_column, to_column)
  def move_row_attribute(row_indx, from_column, to_column)
    the_value = worksheet[row_indx, column_index(from_column)]
    put_row_attribute(row_indx, to_column, the_value)
    put_row_attribute(row_indx, from_column, nil)
  end

  # add_staged_change(indx, clear_attribute, column_name)
  def clear_row_attribute(row_indx, column_name)
    put_row_attribute(row_indx, column_name, nil)
  end

  # add_staged_change(indx, add_attribute, column_name, value_to_add)
  def add_to_row_attribute(row_indx, column_name, value)
    original_value = get_row_attribute(row_indx, column_name)
    unless original_value.to_s.include?(value)
      if original_value.to_s.length > 0
        new_value = "#{original_value};#{value}"
      else
        new_value = value
      end
      put_row_attribute(row_indx, column_name, new_value)
    end
  end

  # adds a row to the bottom of the spreadsheets, and saves the spreadsehet
  def add_row(arr)
    row_id = next_row_id
    arr.each_with_index do |atr, indx|
      c_index = indx + 1
      worksheet[row_id, c_index] = atr
    end
    puts "INFO: Added row #{row_id} to spreadsheet"
    refresh_worksheet
  end

  def ensure_space_to_add_rows
    if next_row_id >= worksheet.max_rows
      worksheet.max_rows = worksheet.max_rows + 10
      refresh_worksheet
    end
  end

  # Adds a row to the bottom of the spreadsehet, saves teh spreadsheet
  # converts the hash to column values first.
  def add_row_with_hash(hsh)
    arr = hash_to_row(hsh)
    add_row(arr)
  end

  def find_by_attribute(column_name, column_value)
    worksheet_hash.select do |item|
      flag = false
      flag = true if item[column_name] == column_value
      flag
    end
  end

  # creates a writeable array for a row
  def hash_to_row(hsh)
    hr = []
    headers.each do |column_name|
      hr << hsh[column_name]
    end
    hr
  end

  def worksheet
    @worksheet ||= workbook.worksheets[worksheet_index]
  end

  def config_path
    File.expand_path('../../config/config.json', File.dirname(__FILE__))
  end

  def spreadsheet_config_path
    File.expand_path('../../config/spreadsheet_config.json', File.dirname(__FILE__))
  end

  def spreadsheet_id
    @spreadsheet_id ||= '1fKbkrlmOf06Kh-TffeefHSptTQtG-fWU0Cgb4PSvVl0'
  end

  def workbook
    @workbook ||= session.spreadsheet_by_key(spreadsheet_id)
  end

  def session
    @session ||= GoogleDrive::Session.from_config(config_path)
  end

  def download_file_by_id(drive_id, path)
    drive_file = session.file_by_id(drive_id)
    full_local_path = "#{path}/#{drive_file.title}"
    drive_file.download_to_file(full_local_path)
    full_local_path
  end

  def write_cache_to_disk
    File.open("/Users/wflanagan/containers/wpstock/api/data/cache/#{json_cache_filename}", 'w') do |f|
      f.puts worksheet_hash.to_json
    end
    true
  end

  def read_cache_from_disk(json_cache_name = nil)
    @worksheet_hash = nil
    json_cache_name = "#{spreadsheet_id}_#{Time.now.year}_#{Time.now.month}_#{Time.now.day}.json" if json_cache_name.nil?
    file = File.read("/Users/wflanagan/containers/wpstock/api/data/cache/#{json_cache_name}")
    @worksheet_hash = JSON.parse(file) if file.present?
    true
  end

  def json_cache_filename
    tn = Time.now
    "#{spreadsheet_id}_#{tn.year}_#{tn.month}_#{tn.day}.json"
  end
end
