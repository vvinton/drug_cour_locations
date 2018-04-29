class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_query, :set_search_options, :set_all_state_coordinators

  def set_query
    @query = {} if @query.nil?
  end

  def set_search_options
    @metrics ||= begin
      Rails.cache.fetch('court_metrics', expires_in: 7.days) do
        ProgramByStateCounts.metrics
      end
    end
  end

  def set_all_state_coordinators
    @all_state_coordinators ||= begin
      asc = Hash.new
      Rails.cache.fetch('state_coordinators', expires_in: 7.days) do
        StateCoordinator.all.each do |sc|
          asc[sc.state] = sc.attributes.to_h.merge('full_name' => sc.full_name)
        end
        asc
      end
      asc
    end
  end
end
