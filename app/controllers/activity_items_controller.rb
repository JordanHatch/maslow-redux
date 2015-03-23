class ActivityItemsController < ApplicationController
  skip_authorization_check

  expose(:need)
  expose(:activity_items, ancestor: :need)

  def index
  end

private
  def note
    @note ||= activity_items.build
  end
  helper_method :note
end
