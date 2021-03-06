class ProgramsInformationController < ApplicationController
  ActionController::Parameters.permit_all_parameters = true

  before_filter :is_admin?, only: [:edit, :update]
  before_filter :find_program_information, only: [:edit, :update]

  def index
    compose_query
    @results = ProgramInformation.search(
      @search.to_s,
      where: @conditions,
      aggs: [:program_type, :state],
      page: params[:page],
      per_page: 10,
      load: false
    )
    @all_results = ProgramInformation.search(@search.to_s, where: @conditions, load: false)
  end

  def statistic
    compose_query
    @results = ProgramInformation.search(
      @search.to_s,
      where: @conditions,
      aggs: [:program_type, :state],
      page: params[:page],
      per_page: 10,
      load: false
    )
    @all_results = ProgramInformation.search(@search.to_s, where: @conditions, load: false)
  end

  def nearbys
    compose_query
    @conditions.delete(:zip_code)
    @query[:z] = []
    @res = ProgramInformation.search(
      '*',
      where: @conditions,
      aggs: [:program_type, :state],
      page: 0,
      per_page: 5,
      limit: 5,
      order: {_geo_distance: {coordinates: {lat: @center[:lat], lon: @center[:lng]}, order: "asc", unit: "mi"} },
      load: false
    )
    @all_results = @results = compose_structure(@res)
    @filters
  end

  def update
    @pi.assign_attributes(params[:program_information])
    if @pi.save
      flash[:success] = "Record has been updated!"
      redirect_to root_path
    else
      flash.now[:error] = "Sorry! We were unable to update that record."
      render "edit"
    end
  end

  private

  def compose_structure(res)
    @filters = { "program_type" => [], "state" => [] }
    structure = []
    state_counts = Hash.new(0)
    type_counts = Hash.new(0)
    res[0..4].each do |r|
      structure << r
      state_counts[(r.state || '')] += 1
      type_counts[(r.program_type || '')] +=1
    end
    @filters["program_type"] = type_counts.map{|k,v| {"key" => k,"doc_count" => v} }
    @filters["state"] = state_counts.map{|k,v| {"key" => k,"doc_count" => v} }
    structure
  end

  def is_admin?
    current_user && current_user.role.name == 'admin'
  end

  def find_program_information
    @pi = ProgramInformation.find(params[:id])
  end

  def compose_query
    @center = {lat: params[:lat].to_f, lng: params[:lng].to_f} if params[:lat] && params[:lng]

    @search = (params[:q].presence || "*").to_s
    @conditions = {}
    @conditions[:state] = params[:s].uniq if params[:s].present?
    @conditions[:program_type] = params[:t].uniq if params[:t].present?
    @conditions[:zip_code] = params[:z].uniq if params[:z].present? && (!params[:v] || params[:v] && params[:v].include?('Map'))

    @query = {
      t: (@conditions[:program_type] || []),
      s: (@conditions[:state] || []),
      z: (@conditions[:zip_code] || []),
      q: @search,
      v: (params[:v] || ['Map', 'List'])
    }
  end

end
