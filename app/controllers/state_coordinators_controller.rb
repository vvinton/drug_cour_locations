class StateCoordinatorsController < ApplicationController
  def index
    @coordinators = StateCoordinator.all
  end
end
