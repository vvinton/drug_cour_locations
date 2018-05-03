# Search takes the params of the query, and returns the query handled for the
# type of query
class SearchHelper
  attr_accessor :params

  class << self
    def search(params = {})
      helper = new(params)
      helper.call
    end

		def description(params = {})
			helper = new(params)
			helper.description
		end
  end

  def initialize(params = {})
    @params = params
    @results = ProgramInformation.all
  end

  def call
    add_program_types_to_query if program_types.present?
    add_states_to_query        if states.present?
    add_search_to_query        unless query.blank?
    add_pagination
    @results
  end

	def description
		str = "Showing courts matching <span class='search-description-parameters'>"
	  str << "states: #{states.join(', ')} & " if states.present?
		str << "court types: #{program_types.join(', ')} & " if program_types.present?
		str << "search string: #{query}" unless query.blank?
		str = str.gsub(/\& $/, '')
		str << '</span>'
		str = "Showing all courts" if !states.present? && !program_types.present? && query.blank?
		str
	end

  def add_program_types_to_query
    @results = @results.where(program_type: program_types)
  end

  def add_states_to_query
    @results = @results.where(state: states)
  end

  def add_search_to_query
		search_query = build_search_query
    @results = @results.where(search_query[:sql], *search_query[:queries])
  end

	# Builds the SQL query for the search.
	def build_search_query
		str = ""
		queries = []
		fields_list.each_with_index do |field, indx|
			str << " OR " unless indx == 0
			str << "#{field} ILIKE ?"
			queries << "%#{query}%"
		end
		{ sql: str, queries: queries }
	end

	def fields_list
		%w[program_name court_name program_type address city state
			 zip_code phone_number email website county]
	end

  def add_pagination
    @results = @results.page(page).per(per)
  end

  def states
    @states ||= params.dig(:states)
  end

  def program_types
    @program_types ||= params.dig(:program_type)
  end

  def query
    @query ||= (params.dig(:q) || params.dig(:search)).to_s
  end

  def page
    @page ||= params.fetch(:page, 1)
  end

  def per
    @per ||= params.fetch(:per, 20)
  end
end
