class Settings::EvidenceTypesController < Settings::BaseController

  def create
    create_or_update(:create, :new)
  end

  def update
    create_or_update(:update, :edit)
  end

private
  helper_method :evidence_types, :evidence_type

  def evidence_types
    @evidence_types ||= EvidenceType.all
  end

  def evidence_type
    @evidence_type ||=
      params.key?(:id) ?
        evidence_types.find(params[:id]) :
        evidence_types.build
  end

  def evidence_type_params
    params.require(:evidence_type).permit(:name, :description, :kind)
  end

  def create_or_update(key, action)
    evidence_type.assign_attributes(evidence_type_params)

    if evidence_type.save
      flash.notice = I18n.t("flash_messages.settings.evidence_types.#{key}")
      redirect_to settings_evidence_types_path
    else
      render action: action
    end
  end

end
