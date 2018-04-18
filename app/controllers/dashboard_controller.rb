class DashboardController < ApplicationController
  ActionController::Parameters.permit_all_parameters = true
  def index
    @query = {}
  end
end
