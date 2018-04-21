require 'json'

module Api
  module V1
    class ApiController < ApplicationController
      def metrics
        metrics = ProgramByStateCounts.metrics
        render json: metrics
      end

      # Renders the state boundaries, which are needed for drawing the USA
      # map
      def boundaries
        render json: $boundary_hash
      end

      def color_legend
        render json: ProgramByStateCounts.color_legend
      end
    end
  end
end
