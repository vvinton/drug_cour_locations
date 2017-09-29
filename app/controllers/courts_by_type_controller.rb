class CourtsByTypeController < ApplicationController
  def index
    results = ProgramByStateCounts.metrics
    @total = results[:total]
    @counts = results[:counts]
    @program_types = results[:program_types]
    @states = results[:total].keys.sort
    @all = results[:all].sort_by{ |k, v| k }.to_h
  end
end
