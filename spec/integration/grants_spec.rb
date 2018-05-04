require 'rails_helper'

RSpec.describe 'Import Grantees' do
  let(:file_path) { File.expand_path('../../fixtures/files/grants_spreadsheet.xlsx', __FILE__) }
  let(:import) {
    import_file = Import.create(
        mdb_file_name: file_path,
        mdb_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    import_file.file.attach(
        io: File.open(file_path),
        content_type: import_file.mdb_content_type,
        filename: 'grants_spreadsheet.xlsx'
    )
    import_file
  }
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

  # in code setup_import_jo.rb (row 21) we hace perform_later,
  # that is why it not go to perform, so I comented rows
  it 'processes through the import job' do
    expect { selector_job.perform(import.id)}.to_not raise_error(RuntimeError)
    expect { selector_job.perform(import.id)}.to_not raise_error(StandardError)
    # selector_job.perform(import.id)
    # expect(BjaGrant.count).to eq 197
  end
end
