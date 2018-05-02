require 'rgb'

class ProgramByStateCounts
  attr_accessor :counts, :states, :program_types, :totals, :all, :totals_by_type

  class << self
    def metrics
      helper = new
      helper.run
      helper.color_code
      {
        program_types:  helper.program_types.sort,
        counts:         helper.counts,
        totals:         helper.totals,
        totals_by_type: helper.totals_by_type,
        states:         helper.totals.keys.sort,
        downloads:      helper.download_links,
        coordinators:   helper.state_coordinators,
        color_code:     helper.color_code,
        all:            helper.all
      }
    end

    def color_legend
      helper = new
      helper.color_map
    end
  end

  def initialize
    @counts = {}
    @totals_by_type = {}
    @states = []
    @program_types = []
    @totals = {}
    @all = {}
  end

  def all_data
    @all_data ||= ProgramInformation.all.to_a.map { |x| x.attributes.to_hash }
  end

  # adds the download links to the file
  def download_links
    @download_links ||= begin
      dl = {}
      @totals.keys.sort.each do |state|
        dl[state] = "/programs_information.csv?states%5B%5D=#{state}"
      end
      dl
    end
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
      state = state.strip
      program_type = pi['program_type']
      program_type = 'Other' if program_type.blank?
      program_type = 'Other' if program_type.to_s.downcase.include?('other')
      program_type = program_type.strip
      program_type = program_type.gsub(/ Court$/, '')
      @counts[state] = {} if @counts[state].nil?
      @states << state
      @program_types << program_type
      @counts[state][program_type] = 0 if @counts[state][program_type].nil?
      @counts[state][program_type] += 1
      @totals_by_type[program_type] = 0 if @totals_by_type[program_type].nil?
      @totals_by_type[program_type] += 1
      @totals[state] = 0 if @totals[state].nil?
      @totals[state] += 1
      @all[program_type] = 0 if @all[program_type].nil?
      @all[program_type] += 1
      @states = @states.uniq
      @program_types = @program_types.uniq
    end
    ensure_states_present_with_zero_counts
  end

  def ensure_states_present_with_zero_counts
    states_list.each do |state|
      set_zero_count_if_required(state)
    end
  end

  def set_zero_count_if_required(state)
    @counts[state] = {} unless @counts.dig(state).present?
    @totals[state] = 0 unless @totals.dig(state).present?
    @program_types.each do |program_type|
      @counts[state][program_type] = 0 unless @counts.dig(state, program_type).present?
    end
  end

  def color_code
    @color_code ||= begin
      color_code = {}
      top_value = @totals.keys.map { |state| @totals[state] }.sort.last
      top_value_increment = (top_value / 10).to_i
      @totals.keys.each do |state|
        value = @totals[state].to_i
        color_index = (value.to_f / top_value_increment.to_f).floor rescue 0
        percentile = (value.to_f / top_value.to_f).floor rescue 0
        color_code[state] = {color: color_map[color_index], percentile: percentile, description: "#{percentile}% of the largest drug treatment court state" }
      end
      states_list.each do |state|
        unless color_code[state]
          color_code[state] = {
            color: '#f1f1f1',
            percentile: 0,
            description: "0% of the largest drug treatment court state"
          }
        end
      end
      color_code
    end
  end

  def base_color
    # old color base #004fa3
    # #005099
    @base_color ||= RGB::Color.from_rgb_hex('#005099')
  end

  # The breakdown of the maps values
  def color_map
    @color_map ||= begin
      hsh = { 10 => base_color.to_rgb_hex }
      9.downto(0).each do |indx|
        lighten_amount = (9 - indx) * 10
        hsh[indx] = base_color.lighten_percent(lighten_amount).to_rgb_hex
      end
      hsh
    end
  end


  def states_list
    [
      "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut",
      "Delaware", "District of Columbia", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois",
      "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts",
      "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada",
      "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota",
      "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
      "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia",
      "Wisconsin", "Wyoming", "American Samoa", "Guam", "Northern Mariana Islands",
      "Puerto Rico", "U.S. Minor Outlying Islands", "U.S. Virgin Islands"
    ]
  end
end
