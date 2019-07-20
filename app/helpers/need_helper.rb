module NeedHelper
  def format_need_goal(goal)
    return "" if goal.blank?

    words = goal.split(" ")
    words.first[0] = words.first[0].upcase
    words.join(" ")
  end

  # If no criteria present, insert a blank
  # one.
  def criteria_with_blank_value(criteria)
    criteria.present? ? criteria : [""]
  end

  def paginate_needs(needs)
    paginate needs
  end

  def canonical_need_goal(need)
    return unless need.canonical_need
    need.canonical_need.goal
  end

  def bookmark_icon(bookmarks = [], need_id)
    bookmarks.include?(need_id.to_s) ? 'bookmark-selected' : 'bookmark-unselected'
  end

  def current_user_can_edit_need?(need)
    current_user.can?(:update, Need) && !need.closed?
  end
end
