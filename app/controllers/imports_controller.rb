class ImportsController < ApplicationController

  def create
    @import_file = Import.new
    @import_file.mdb_content_type = params[:import][:content_type]
    @import_file.mdb_file_name = params[:import][:file].original_filename
    if @import_file.save!
      @import_file.file.attach(
        io: File.open(params[:import][:file].tempfile.path),
        content_type: params[:import][:content_type],
        filename: params[:import][:file].original_filename
      )
      SetupImportJob.perform_later(@import_file.id)
      flash[:notice] = "Successfuly uploaded. Import will begin momentarily."
    else
      flash[:error]  = "There was a problem saving the import file. Please contact support."
    end
    redirect_to imports_path
  rescue => e
    puts "#{e.inspect}"
    puts "#{e.backtrace}"
    raise e
  end

  private

  def import_params
    params.require(:import).permit(:file)
  end
end
