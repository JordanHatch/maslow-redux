class TagsController < ApplicationController
  def show
    authorize! :show, tag_instance

    @bookmarks = current_user.bookmarks
  end

  def edit
    authorize! :edit, tag_instance
  end

  def update
    authorize! :edit, tag_instance

    if tag_instance.update_attributes(tag_attributes)
      redirect_to tag_path(tag_instance)
    else
      render action: :edit
    end
  end

private
  def tag_type
    @tag_type ||= tag_instance.tag_type
  end
  helper_method :tag_type

  def tag_instance
    @tag_instance ||= Tag.with_pages.find(params[:id])
  end
  helper_method :tag_instance

  def needs
    @needs ||= Need.with_tag_id(tag_instance)
  end
  helper_method :needs

  def tag_attributes
    params.require(:tag).permit(:body, priority_need_ids: [])
  end

  def priority_needs
    @priority_needs ||= tag_instance.priority_need_ids.uniq.map {|need_id|
      needs.find {|need| need.id == need_id }
    }.compact
  end
  helper_method :priority_needs

  def other_needs
    @other_needs ||= needs.reject {|need| priority_needs.include?(need) }
  end
  helper_method :other_needs
end
