class NeedCriteriaController < ApplicationController

  def edit
    authorize! :update, Need

    @form = NeedCriteriaForm.from_model(need)
  end

  def update
    authorize! :update, Need

    @form = NeedCriteriaForm.from_params(params, id: need.id)

    if @form.valid?
      need.met_when = @form.to_criteria
      need.save_as(current_user)

      if params[:commit] == I18n.t('formtastic.actions.need_criteria.save_add_more')
        @form.add_extra_criteria!
        render action: :edit
      else
        redirect_to need_path(need)
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
