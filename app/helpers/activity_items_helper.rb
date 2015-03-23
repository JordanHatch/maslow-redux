module ActivityItemsHelper

  def format_changed_fields_list(field_names)
    list = field_names.map {|field|
      content_tag :span, sanitize(format_field_name(field))
    }

    if list.size > 1
      list[-1] = "and #{list[-1]}"
    end

    separator = (list.size > 2) ? ', ' : ' '

    list.join(separator).html_safe
  end

  def format_field_name(name)
    name.humanize
  end

end
