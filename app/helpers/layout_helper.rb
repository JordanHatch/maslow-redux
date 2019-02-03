module LayoutHelper
  def nav_link_to(label, url, icon: nil, match_prefix: false)

    if content_for?(:selected_navigation_url)
      selected = (url == content_for(:selected_navigation_url))
    elsif match_prefix
      selected = current_page_or_prefix?(url)
    else
      selected = current_page?(url)
    end

    selected_class = selected ? 'selected' : ''
    glyphicon_class = icon.present? ? "glyphicon-#{icon}" : ''

    content_tag(:li, class: selected_class) do
      link_to(url) do
        content_tag(:span, nil, class: glyphicon_class) + label
      end
    end
  end

  def current_page_or_prefix?(url)
    pattern = /^#{Regexp.escape(url)}/
    current_page?(url) || request.fullpath =~ pattern
  end

  def simpler_format(string)
    simple_format h(string)
  end
end
