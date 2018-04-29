require 'rails_helper'

RSpec.describe 'Import MDB import' do
  let(:file_path) { File.expand_path('../../fixtures/files/mdb_db.mdb', __FILE__) }
  let(:import) { Import.create(mdb_file_name: file_path, mdb_content_type: 'application/vnd.ms-access') }
  let(:job) { MdbImportJob.new }
  let(:selector_job) { SetupImportJob.new }
  before do
    ActiveJob::Base.queue_adapter = :test
    allow_any_instance_of(Paperclip::Attachment).to receive(:path).and_return(file_path)
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
