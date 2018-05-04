# Checks the format of the file, and then launches the appropriate
# job type for the file for importing
class SetupImportJob < SpreadsheetImportJob
  queue_as :default

  def perform(import_file_id)
    @record = Import.find import_file_id
    if @record.file.content_type.to_s.include?('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      handle_spreadsheet_import_record
    elsif @record.file.content_type.to_s.include?('vnd.ms-access')
      handle_mdb_database_import_record
    else
      raise UnsupportedFileFormat.new 'Not a supported file format (modern Excel spreadsheet or older Microsoft Access file) not detected.'
    end
  end

  def handle_spreadsheet_import_record
    frfc = get_first_row_first_column
    raise StandardError.new 'Not a supported spreadsheet format, no identified first row first column value' unless potential_match_terms.include?(frfc)
    ProgramInformationSpreadsheetImportJob.perform_later(@record.id) if frfc == program_information_match_term
    GrantImportJob.perform_later(@record.id)                         if frfc == grant_match_term
    StateCoordinatorImportJob.perform_later(@record.id)              if frfc == state_coordinator_match_term
  end

  def handle_mdb_database_import_record
    MdbImportJob.perform_later(@record.id)
  end
end
