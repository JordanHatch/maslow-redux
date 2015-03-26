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

  def format_field_value(value)
    if value.is_a?(Array)
      if value.empty? || value.reject(&:blank?).empty?
        "<ul><li><em>blank</em></li></ul>".html_safe
      else
        content_tag :ul, value.map {|item|
          content_tag :li, sanitize(item)
        }.join.html_safe
      end
    else
      if value.blank? || value.to_s.strip.blank?
        "<em>blank</em>".html_safe
      else
        value.to_s
      end
    end
  end

end
