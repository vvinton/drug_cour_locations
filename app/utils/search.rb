class Search
	class << self
		
		def get_search(params)
			@states = []
			states = params[:states]
			program_types = params[:program_type]
			query = params[:q]
			@results =  ProgramInformation.where(program_type: program_types).or(ProgramInformation.where(state: states)) if program_types.present? || states.present?
			@results = ProgramInformation.where(program_type: program_types ).where(state: states )  if program_types.present? && states.present?
			@results =ProgramInformation.where('state ILIKE ? OR program_type ILIKE ?' , "%#{query}%", "%#{query}%") if query != ''
			end
			return @results
		end	
	end	
end	