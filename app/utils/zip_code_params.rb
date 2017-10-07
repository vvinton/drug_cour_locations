class ZipCodeParams
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def zip_code_params
    @zip_code_params ||= params[:z]&.uniq
  end

  def matching_zip_codes
    @matching_zip_codes ||= begin
      mzc = []
      zip_code_params.each do |szip|
        next if ['none', 'nil'].include?(szip)
        handle_zip_expansion(szip).each { |zip| mzc << zip }
      end
      mzc = mzc.uniq
      mzc
    end
  end

  def handle_zip_expansion(zip)
    zip = zip.to_s
    zip = zip if zip.length == 3
    zip = handle_one_digit_expansion(zip) if zip.length == 1
    zip = handle_two_digit_expansion(zip) if zip.length == 2
    Array(zip)
  end

  def handle_one_digit_expansion(zip)
    (0..99).to_a.map { |x| "#{zip}#{format('%02d', x)}" }
  end

  def handle_two_digit_expansion(zip)
    (0..9).to_a.map { |x| "#{zip}#{x}" }
  end
end
