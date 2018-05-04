require 'rails_helper'

RSpec.describe 'Import MDB import' do
  let(:original_filename) { 'mdb_db.mdb' }
  let(:content_type) { 'application/vnd.ms-access' }
  let(:headers) { "Content-Disposition: form-data; name=\"import[file]\"; filename=\"#{original_filename}\"\r\nContent-Type: #{content_type}\r\n" }
  let(:file_path) { File.expand_path('../../fixtures/files/mdb_db.mdb', __FILE__) }
  let(:file_params) do
    ActionDispatch::Http::UploadedFile.new(
      tempfile: Tempfile.open(path: file_path),
      content_type: content_type,
      headers: headers,
      original_filename: original_filename

    )
  end
  let(:import) do
    import = Import.create(mdb_file_name: file_path,
                          mdb_content_type: content_type,
                          file: file_params)
    import
  end
  let(:job) { MdbImportJob.new }
  let(:selector_job) { SetupImportJob.new }
  before do
    begin
      ActiveJob::Base.queue_adapter = :test
      import.file.attach(
        io: File.open(file_path),
        content_type: import.mdb_content_type,
        filename: 'mdb_db.mdb'
      )
    rescue => e
      binding.pry
      pp e.backtrace
      raise e
    end
    ProgramInformation.delete_all
  end

  it 'maps file successfully' do
    job.perform(import.id)
    expect(ProgramInformation.count).to eq 3283
  end

  it 'runs through selector job' do
    selector_job.perform(import.id)
    expect(MdbImportJob).to have_been_enqueued
  end
end
