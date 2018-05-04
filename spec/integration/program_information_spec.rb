require 'rails_helper'

RSpec.describe 'Import Program Information' do
  let(:file_path) { File.expand_path('../../fixtures/files/db_spreadsheet.xlsx', __FILE__) }
  let(:import) {
    import_file = Import.create(
        mdb_file_name: file_path,
        mdb_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )
    import_file.file.attach(
        io: File.open(file_path),
        content_type: import_file.mdb_content_type,
        filename: 'db_spreadsheet.xlsx'
    )
    import_file
  }
  let(:job) { ProgramInformationSpreadsheetImportJob.new }
  let(:selector_job) { SetupImportJob.new }
  before do
    ActiveJob::Base.queue_adapter = :test
    allow_any_instance_of(Paperclip::Attachment).to receive(:path).and_return(file_path)
    ProgramInformation.delete_all
  end

  it 'maps file successfully' do
    job.perform(import.id)
    expect(ProgramInformation.count).to eq 3472
  end

  it 'runs through selector job' do
    selector_job.perform(import.id)
    expect(ProgramInformationSpreadsheetImportJob).to have_been_enqueued
  end
end
