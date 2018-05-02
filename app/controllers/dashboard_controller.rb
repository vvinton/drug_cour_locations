class DashboardController < ApplicationController
  ActionController::Parameters.permit_all_parameters = true
  def index
  end

  def clear_cache
    Rails.cache.clear
    redirect_to '/'
  end
end
