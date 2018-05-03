class ImportsController < ApplicationController

  def create
    begin
      @import_file = Import.new(import_params)
      @import_file.mdb_content_type = params[:import][:content_type]
      @import_file.mdb_file_name    = params[:import][:file].original_filename
      if @import_file.save
        puts "Made it here"
        puts "#{@import_file.file.attached?}"
        @import_file.file.attach(
          io: File.open(params[:import][:file].tempfile.path),
          content_type: params[:import][:content_type],
          filename: params[:import][:file].original_filename
        ) unless @import_file.file.attached?
        SetupImportJob.perform_later(@import_file.id)
        flash[:notice] = "Successfuly uploaded. Import will begin momentarily."
      else
        flash[:error]  = "There was a problem saving the import file. Please contact support."
      end
    rescue => e
      puts "#{e.inspect}"
      puts "#{e.backtrace}"
      flash[:error]  = "There was an exception storing the import file. Please contact support."
    end
    redirect_to imports_path
  end

  private

  def import_params
    params.require(:import).permit(:file)
  end
end
