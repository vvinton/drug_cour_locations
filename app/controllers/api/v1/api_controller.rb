require 'json'

module Api
  module V1
    class ApiController < ApplicationController
      def metrics
        render json: metrics_data
      end

      def metrics_data
        @metrics_data ||= begin
          Rails.cache.fetch('court_metrics', expires_in: 12.hours) do
            ProgramByStateCounts.metrics
          end
        end
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
