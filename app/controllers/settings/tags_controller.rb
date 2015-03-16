class Settings::TagsController < Settings::BaseController
  expose(:tag_type)
  expose(:tags, ancestor: :tag_type)

  # NOTE: We can't use 'tag' here, as it conflicts with the ActiveSupport
  # helper of the same name and causes all kinds of bad things to happen.
  #
  expose(:tag_instance, model: :tag)

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

end
