class ActivityItemsController < ApplicationController
  expose(:need)
  expose(:activity_items, ancestor: :need)

  def index
    authorize! :index, ActivityItem
  end

private
  def note
    @note ||= activity_items.build
  end
  helper_method :note
end
