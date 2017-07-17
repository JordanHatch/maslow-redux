class Settings::TagsController < Settings::BaseController
  expose(:tag_type)
  expose(:tags, from: :tag_type)

  def create
    tag_instance.assign_attributes(tag_attributes)

    if tag_instance.save
      redirect_to settings_tag_type_path(tag_type)
    else
      render action: :new
    end
  end

  def update
    if tag_instance.update_attributes(tag_attributes)
      redirect_to settings_tag_type_path(tag_type)
    else
      render action: :edit
    end
  end

  def destroy
    tag_instance.destroy
    redirect_to settings_tag_type_path(tag_type)
  end

private
  def tag_attributes
    params.require(:tag).permit(:name)
  end

  def tag_instance
    if params.key?(:id)
      @tag ||= tag_type.tags.find(params[:id])
    else
      @tag ||= tag_type.tags.build
    end
  end
  helper_method :tag_instance

end
