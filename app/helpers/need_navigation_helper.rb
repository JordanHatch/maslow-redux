module NeedNavigationHelper

  def need_navigation_items(need)
    [
      {
        name: 'Overview',
        url: need_path(need),
        icon: 'tent',
      },
      {
        name: 'Activity',
        url: activity_need_path(need),
        icon: 'inbox',
      },
      {
        name: 'Justification and evidence',
        url: evidence_need_path(need),
        icon: 'th-list',
      },
      {
        name: 'Response',
        url: need_responses_path(need),
        icon: 'globe',
      },
      # {
      #   name: 'Performance',
      #   url: '#',
      #   icon: 'stats',
      # }
    ]
  end

  def navigation_selected_item?(item)
    item[:url] == request.path
  end

end
