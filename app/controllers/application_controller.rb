class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_query, :set_search_options

  def set_query
    @query = {} if @query.nil?
  end

  def set_search_options
    @metrics ||= begin
      Rails.cache.fetch('court_metrics', expires_in: 12.hours) do
        ProgramByStateCounts.metrics
      end
    end
  end
end
