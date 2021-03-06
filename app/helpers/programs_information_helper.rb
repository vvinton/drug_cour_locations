module ProgramsInformationHelper

  def link_to_facet(url_param_name, result_name, result_count = nil, highlight = false)
    params_string = CGI.unescape(
      if checked = @query[url_param_name].include?(result_name)
        @query.merge(url_param_name => (@query[url_param_name] - [result_name]))
      else
        @query.merge(url_param_name => (@query[url_param_name] | [result_name]))
      end.to_query
    )
    caption = result_name + (result_count ? " (#{result_count})" : '')
    if checked && highlight
      content_tag(:strong){link_to(caption, "/programs_information?#{params_string}")}
    else
      link_to(caption, "/programs_information?#{params_string}")
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
    link_to('Download CSV', "/programs_information.csv?#{params_string}", class: "btn btn-default", role: "button", id: 'csv-export-link')
  end

  def link_to_nearbys_csv_export
    params_string = CGI.unescape(@query.merge({lat: @center[:lat], lng: @center[:lng]}).to_query)
    link_to('Download CSV', "nearbys.csv?#{params_string}", class: "btn btn-default", role: "button", id: 'csv-export-link')
  end

  def view_option_title
    if @query[:v].size > 1
     'Map & List'
    else
      @query[:v].first || 'Map & List'
    end
  end

  def link_to_state_option(caption, states)
    params_string = CGI.unescape(
      @query.merge(s: states).to_query
    )
    link_to(caption, "/programs_information?#{params_string}")
  end
end
