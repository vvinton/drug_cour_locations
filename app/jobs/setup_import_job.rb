# Checks the format of the file, and then launches the appropriate
# job type for the file for importing
class SetupImportJob < SpreadsheetImportJob
  queue_as :default

  def perform(import_file_id)
    @record = Import.find import_file_id
    if @record.mdb_content_type.to_s.include?('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      handle_spreadsheet_import_record
    elsif @record.mdb_content_type.to_s.include?('vnd.ms-access')
      handle_mdb_database_import_record
    else
      raise UnsupportedFileFormat.new 'Not a supported file format (modern Excel spreadsheet or older Microsoft Access file) not detected.'
    end
  end

  def handle_spreadsheet_import_record
    frfc = get_first_row_first_column
    raise StandardError.new 'Not a supported spreadsheet format, no \'ID\' or \'Fiscal Year\' in first row first column' unless ['ID', 'Fiscal Year'].include?(frfc)
    ProgramInformationSpreadsheetImportJob.perform_later(@record.id) if frfc == 'ID'
    GrantImportJob.perform_later(@record.id)              if frfc == 'Fiscal Year'
  end

  def handle_mdb_database_import_record
    MdbImportJob.perform_later(@record.id)
  end
end
