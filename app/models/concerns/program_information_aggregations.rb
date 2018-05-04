module ProgramInformationAggregations
  extend ActiveSupport::Concern

  class_methods do
    def calculations_aggregations
      {
        "state": {
          aggs: {
            "program_type": {
              "terms": {
                "field": "program_type",
                'size': 20
              }
            } # Placeholder to ensure all data was fetched. ES wasn't aggregating across all documents, and this was quicker than going into in depth troubleshooting after a few likely candidate solutions were tested. Don't do this in production.
          }
        }
      }
    end
  end
end
