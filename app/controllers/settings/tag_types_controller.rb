class Settings::TagTypesController < Settings::BaseController
  expose(:tag_type)

  def create
    tag_type.assign_attributes(tag_type_attributes)

    if tag_type.save
      redirect_to settings_tag_type_path(tag_type)
    else
      render action: :new
    end
  end

  def update
    if tag_type.update_attributes(tag_type_attributes)
      redirect_to settings_tag_type_path(tag_type)
    else
      render action: :edit
    end
  end

private
  def tag_type_attributes
    params.require(:tag_type).permit(:name)
  end

end
