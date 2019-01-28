class TagsController < ApplicationController
  def show
    authorize! :show, tag_instance

    @bookmarks = current_user.bookmarks
  end

private
  def tag_type
    @tag_type ||= TagType.index_pages.find_by_identifier(params[:tag_type_id])
  end
  helper_method :tag_type

  def tag_instance
    @tag_instance ||= tag_type.tags.find(params[:id])
  end
  helper_method :tag_instance

  def needs
    @needs ||= Need.with_tag_id(tag_instance)
  end
  helper_method :needs
end
