class ProgramByStateCounts
  attr_accessor :counts, :states, :program_types, :totals, :all

  class << self
    def metrics
      helper = new
      helper.run
      {
        program_types: helper.program_types.sort,
        counts: helper.counts,
        total: helper.totals,
        states: helper.totals.keys.sort,
        all: helper.all
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
    @all_data ||= ProgramInformation.all.to_a.map {|x| x.attributes.to_hash }
  end

  def run
    puts "Count: #{all_data.length}"
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
    @program_types.uniq!
  end
end
