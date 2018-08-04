class NeedEvidenceController < ApplicationController

  def show
    authorize! :read, Need
  end

  def edit
    authorize! :update, Need

    @form = NeedEvidenceForm.from_model(need)
  end

  def update
    authorize! :update, Need

    @form = NeedEvidenceForm.from_params(params, id: need.id)

    if @form.valid?
      @form.evidence_items.each do |evidence_form|
        evidence_item = need.evidence_items.find_or_create_by(evidence_type_id: evidence_form.evidence_type_id)
        evidence_item.update_attributes(value: evidence_form.value)
      end

      redirect_to need_evidence_path(need)
    else
      render action: :edit
    end
  end

private
  def need
    @need ||= Need.find(params[:need_id])
  end
  helper_method :need

end
