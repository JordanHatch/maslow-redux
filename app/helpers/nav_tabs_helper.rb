module NavTabsHelper
  def nav_tabs_for(need)
    tabs = []
    tabs << [ "View", need_path(need) ]
    tabs << [ "Activity", need_activity_items_path(need) ]
    tabs << [ "Edit", edit_need_path(need) ] if !need.duplicate? && current_user.can?(:update, Need)
    tabs
  end
end
