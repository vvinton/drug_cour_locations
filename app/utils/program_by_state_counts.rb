class ProgramByStateCounts
  attr_accessor :counts, :states, :program_types, :totals, :all

  class << self
    def metrics
      helper = new
      helper.run
      helper.color_code
      {
        program_types: helper.program_types.sort,
        counts:        helper.counts,
        total:         helper.totals,
        states:        helper.totals.keys.sort,
        coordinators:  helper.state_coordinators,
        color_code:    helper.color_code,
        all:           helper.all
      }
    end
  end

  def initialize
    @counts = {}
    @states = []
    @program_types = []
    @totals = {}
    @all = {}
  end

  def all_data
    @all_data ||= ProgramInformation.all.to_a.map { |x| x.attributes.to_hash }
  end

  def state_coordinators
    @state_coordinators ||= begin
      state_coordinators = {}
      StateCoordinator.all.each do |sc|
        state_coordinators[sc.state] = {}
        state_coordinators[sc.state][:first_name] = sc&.first_name
        state_coordinators[sc.state][:last_name]  = sc&.last_name
        state_coordinators[sc.state][:title]      = sc&.title
        state_coordinators[sc.state][:agency]     = sc&.agency
        state_coordinators[sc.state][:address]    = sc&.address
        state_coordinators[sc.state][:city]       = sc&.city
        state_coordinators[sc.state][:state]      = sc&.state
        state_coordinators[sc.state][:zip]        = sc&.zip
        state_coordinators[sc.state][:email]      = sc&.email
        state_coordinators[sc.state][:phone]      = formatted_phone(sc&.phone)
        state_coordinators[sc.state][:website]    = sc&.website
      end
      state_coordinators
    end
  end

  def formatted_phone(raw_phone)
    raw_phone.to_s.strip.gsub(/ext\.$/, '').strip
  end

  def run
    all_data.each do |pi|
      state = pi['state']
      program_type = pi['program_type']
      program_type = 'Other' if program_type.nil?
      program_type = 'Other' if program_type.to_s.downcase.include?('other')
      program_type = program_type.strip
      @counts[state] = {} if @counts[state].nil?
      @states << state
      @program_types << program_type
      @counts[state][program_type] = 0 if @counts[state][program_type].nil?
      @counts[state][program_type] += 1
      @totals[state] = 0 if @totals[state].nil?
      @totals[state] += 1
      @all[program_type] = 0 if @all[program_type].nil?
      @all[program_type] += 1
    end
    @program_types = @program_types.uniq!
  end

  def color_code
    @color_code ||= begin
      color_code = {}
      top_value = @totals.keys.map { |state| @totals[state] }.sort.last
      buckets = 3
      first_third = top_value / buckets
      second_third = first_third + first_third
      last_third = top_value + 1
      @totals.keys.each do |state|
        value = @totals[state].to_i
        color_code[state] = {color: '#dddddd', description: 'none'} if value == 0 || value.nil?
        color_code[state] = {color: '#ea6f43', description: 'bottom third'} if (value > 0 && value <= first_third)
        color_code[state] = {color: '#f4cc55', description: 'middle third'} if (value > first_third && value <= second_third)
        color_code[state] = {color: '#699d88', description: 'top third'} if (value > second_third && value <= top_value)
      end
      color_code
    end
  end
end
