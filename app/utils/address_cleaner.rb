# cleans an address, stripping any leading  spaces or , so we can match
# either just state, city and state, or address, city, state
class AddressCleaner
  attr_accessor :args

  class << self
    def clean(term)
      helper = new(term: term)
      helper.call
    end
  end

  def initialize(args)
    @args = args
  end

  def term
    @term ||= args.fetch(:term, '').to_s
  end

  def call
    term.strip.gsub(/^,\W+/, '')
  end
  alias clean call
end
