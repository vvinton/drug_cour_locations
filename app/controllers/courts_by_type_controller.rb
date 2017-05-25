class CourtsByTypeController < ApplicationController
  def index
    results = ProgramByStateCounts.metrics
    @total = results[:total]
    @counts = results[:counts]
    @program_types = results[:program_types]
    @states = results[:total].keys.sort
  end
end
