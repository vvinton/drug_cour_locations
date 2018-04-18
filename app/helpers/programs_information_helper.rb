module ProgramsInformationHelper

  def clean_csv_field(text)
    text.to_s.gsub(',', ' ')
  end

  def clean_csv_phone(text)
    text.to_s.gsub(/ ext\.$/, '')
  end

  # fixes formatting issues on the Zip code from the import to the database
  def clean_zip(text)
    text = text.to_s
    return '' if text.to_s.include?('{')
    zip_array = text.to_s.split('-', 2)
    first_part = zip_array.first
    last_part  = zip_array.last if zip_array.length > 1
    first_part = "0#{first_part}" if first_part&.to_s&.length == 4
    last_part = zip_array.last if zip_array.length > 1
    text = first_part
    text = "#{first_part}-#{last_part}" if !last_part.nil?
    text
  rescue => e
    puts "#{e.inspect}"
    ''
  end

  def link_to_facet(url_param_name, result_name, result_count = nil, highlight = false, additional_class_names = "")
    params_string = CGI.unescape(
      if checked = @query[url_param_name].include?(result_name)
        @query.merge(url_param_name => (@query[url_param_name] - [result_name]))
      else
        @query.merge(url_param_name => (@query[url_param_name] | [result_name]))
      end.to_query
    )
    caption = result_name + (result_count ? " (#{result_count})" : '')
    if checked && highlight
      content_tag(:strong){link_to(caption, "/programs_information?#{params_string}", class: "#{additional_class_names}")}
    else
      link_to(caption, "/programs_information?#{params_string}", class: "#{additional_class_names}")
    end
  end

  def link_to_view_option(caption, opts)
    params_string = CGI.unescape(
      @query.merge(v: (opts)).to_query
    )
    link_to(caption, "/programs_information?#{params_string}")
  end

  def link_to_csv_export
    params_string = CGI.unescape(@query.to_query)
    link_to('Download with current filters', "/programs_information.csv?#{params_string}", id: 'csv-export-link')
  end

  def link_to_all_download
    params_string = CGI.unescape(@query.to_query)
    link_to('Download everything', "/programs_information.csv", id: 'csv-export-all-link', class: 'btn btn-primary')
  end

  def link_to_nearbys_csv_export
    params_string = CGI.unescape(@query.merge({lat: @center[:lat], lng: @center[:lng]}).to_query)
    link_to('Download CSV', "nearbys.csv?#{params_string}", class: "btn btn-default", role: "button", id: 'csv-export-link')
  end

  def view_option_title
    if @query[:v].size > 1
     'Filters '
    else
      @query[:v].first || 'Filters '
    end
  end

  def link_to_state_option(caption, states)
    params_string = CGI.unescape(
      @query.merge(s: states).to_query
    )
    link_to(caption, "/programs_information?#{params_string}")
  end

  def city_state_zip(res)
    [res.city, res.state, res.zip_code].delete_if {|x| x.blank? }.join(", ")
  end

  def popup_text(res, sc)
    str = ''
    str << "<h5>Program Information</h5>"
    str << "<ul class=\'popup-list\' id=\'program-popup-information-#{res.id}>\'>"
    str << "<li>State: #{res.state}</li>"
    str << "<li>County: #{res.country}</li>"
    str << "<li>Court Type: #{res.program_type}</li>"
    str << "<li>Program Name: #{res.program_name}</li>"
    str << "<li>Address: #{res.address}</li>" if res.address
    str << "<li>Website: #{link_to(res.website, res.website)}</li>" if res.website
    str << "</ul>"
    if sc
      str << "<h5>Coordinator</h5>"
      str << "<ul class=\'popup-list\' id=\'coordinator-popup-information\'>"
      str << "<li>" + sc['first_name'] + " " +  sc['last_name'] + "</li>"
      str << "<li>" + sc['title'] + "</li>"
      str << "<li>" + sc['email'] + "</li>"
      str << "<li>" + sc['phone'] + "</li>"
      str << '</ul>'
    end
    raw(str)
  end
end
