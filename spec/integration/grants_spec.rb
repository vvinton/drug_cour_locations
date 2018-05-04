require 'rails_helper'

RSpec.describe 'Import Grantees' do
  let(:file_path) { File.expand_path('../../fixtures/files/grants_spreadsheet.xlsx', __FILE__) }
  let(:import) { Import.create(mdb_file_name: file_path, mdb_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
  let(:job)    { GrantImportJob.new }
  let(:selector_job) { SetupImportJob.new }
  before do
    ActiveJob::Base.queue_adapter = :test
    allow_any_instance_of(Paperclip::Attachment).to receive(:path).and_return(file_path)
  end

  it 'maps file successfully' do
    job.perform(import.id)
    expect(BjaGrant.count).to eq 197
  end

  it 'processes through the import job' do
    selector_job.perform(import.id)
    expect(BjaGrant.count).to eq 197
  end
end
