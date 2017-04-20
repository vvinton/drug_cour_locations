class ImportsController < ApplicationController

  def create
    @import_file = Import.new(import_params)
    if @import_file.save
      MdbImportJob.perform_later(@import_file.id)
      flash[:notice] = "Successfuly upload"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to root_path
  end

  private

  def import_params
    params.require(:import).permit(:mdb)
  end
end
