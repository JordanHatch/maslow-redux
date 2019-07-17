class NeedCriteriaController < ApplicationController

  def show
    authorize! :read, Need
  end

  def edit
    authorize! :update, Need

    @form = NeedCriteriaForm.from_model(need)
  end

  def update
    authorize! :update, Need

    @form = NeedCriteriaForm.from_params(params, id: need.id)

    if @form.valid?
      need.update_attributes(
        met_when: @form.to_criteria
      )

      if params[:commit] == I18n.t('formtastic.actions.need_criteria.save_add_more')
        @form.add_extra_criteria!
        render action: :edit
      else
        redirect_to need_criteria_path(need)
      end
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
