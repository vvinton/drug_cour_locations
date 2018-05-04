require 'geocoder'
require 'moneta'
require 'json'
require 'retryable'

# provides cached access to the Geocoder, so we don't keep redipping the
# same addresses. Stores in the lib folder so we can check it into the
# repo intentionally. Has a method that will write a fixture that can be
# checked in that is the UI's way to dip this.
class CacheGeofind
  class << self
    def search(term)
      helper = new
      resp = helper.call(term)
      helper.store.close
      resp
    end
  end

  def initialize
    ::Geocoder.configure(geocoder_config)
  end

  def geocoder_config
    {
      timeout: 30,
      always_raise: :all,
      api_key: 'AIzaSyCseUWlLI39ewH0al6WhIagAKCLKQEQ4W4',
      use_https: true
    }
  end

  # store for the newly encountered, unmatchable addresses wtih complete
  # addressses
  def unencodable_address_list
    @unencodable_address_list ||= []
  end

  def call(term)
    resp = fixture_get(term)
    resp = get(term) if resp.nil?
    resp = geocode_and_set(term) if resp.nil?
    unencodable_address_list << term if resp.nil?
    resp
  end
  alias_method :search, :call

  def get(term)
    resp = store[term]
    resp = JSON.parse(resp) unless resp.nil?
    resp
  end

  def geocode_and_set(term)
    resp = geocode(term)
    set(term, resp)
    resp
  end

  def set(term, value)
    store[term] = value.to_json if value
  end

  def retry_interval_base
    8
  end

  # Will try to retrieve the Geocoded information 3 times if it gets an error,
  # that is the OverQueryLimitError
  def geocode(term)
    Retryable.retryable(tries: 3,
                        sleep: lambda { |n| retry_interval_base**n },
                        on: Geocoder::OverQueryLimitError) do |retries, exception|
      puts "Retrying #{retries} #{term}" if retries > 0
      sleep(200*retries)
      ::Geocoder.search(term).try(:last).try(:data)
    end
  end

  def store
    @store ||= Moneta.new(:File, dir: cache_path)
  end

  def cache_path
    "#{Rails.root}/lib/geoquery_cache_fixture"
  end

  def unencodable_path
    "#{Rails.root}/lib/unencodable_addresses.json"
  end

  def fixture_path
    "#{Rails.root}/lib/csv/geoquery_cache.json"
  end

  def key?(term)
    store.key?(term)
  end

  def keys
    raw_keys = Dir.entries(cache_path.to_s).select do |f|
      File.file?("#{cache_path}/#{f}")
    end
    raw_keys.map { |key| CGI.unescape(key) }
  end

  # Decodes and counts the keys
  def count
    keys.length
  end

  # Returns everything that is cached in an array, used
  # to write the fixture
  def all
    keys.map { |key| record(key) }
  end

  # Only a subset of Enumberable is implmented, be careful
  def each
    keys.each do |key|
      hsh = record(key)
      yield hsh
    end
  end

  def record(key)
    { 'key' => key, 'value' => get(key) }
  end

  def as_fixture
    hsh = {}
    all.each do |item|
      hsh[item['key']] = item['value']
    end
    hsh
  end

  def fixture_get(term)
    fixture[term]
  end

  def fixture
    @fixture ||= begin
      file = File.read(fixture_path)
      JSON.parse(file)
    end
  end

  def write_cache_fixture
    File.open(fixture_path, 'w') do |f|
      f.write(as_fixture.to_json)
    end
  end

  def write_unencodable_list
    File.open(unencodable_path, 'w') do |f|
      f.write(unencodable_address_list.to_json)
    end
  end
end
