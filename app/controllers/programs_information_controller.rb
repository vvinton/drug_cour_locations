class ProgramsInformationController < ApplicationController
  ActionController::Parameters.permit_all_parameters = true
  before_action :is_admin?, only: %i[edit update]
  before_action :find_program_information, only: %i[edit update]

  def index
    @results = SearchHelper.search(params)
    @description = SearchHelper.description(params)
    states = @results.map(&:state).uniq
    @state_coordinators = @all_state_coordinators
  end

  def statistic
    results = ProgramByStateCounts.metrics
    @total = results[:total]
    @counts = results[:counts]
    @program_types = results[:program_types]
    @states = results[:total].keys.sort
    @all = results[:all].sort_by{ |k, v| k }.to_h
  end

  def update
    @pi.assign_attributes(params[:program_information])
    if @pi.save
      flash[:success] = "Record has been updated!"
      redirect_to root_path
    else
      flash.now[:error] = "Sorry! We were unable to update that record."
      render "edit"
    end
  end

  private

  def is_admin?
    current_user && current_user.role.name == 'admin'
  end

  def find_program_information
    @pi = ProgramInformation.find(params[:id])
  end
end
