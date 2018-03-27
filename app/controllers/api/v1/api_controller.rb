require 'json'

module Api
  module V1
    class ApiController < ApplicationController
      def metrics
        metrics = ProgramByStateCounts.metrics
        render json: metrics
      end
    end
  end
end
