class DecisionsController < ApplicationController
  layout 'skeleton'

  
  def new
    authorize! :create, Decision

    decision.decision_type ||= default_decision_type
  end

  def create
    authorize! :create, Decision

    decision.assign_attributes(decision_params)
    decision.user = current_user

    if decision.save
      redirect_to need_path(need)
    else
      render action: :new
    end
  end

private
  def need
    @need ||= Need.find(params[:need_id])
  end
  helper_method :need

  def decision
    @decision ||= need.decisions.build
  end
  helper_method :decision

  def decision_params
    params.require(:decision).permit(:decision_type, :outcome, :note)
  end

  def default_decision_type
    params[:decision_type] || Decision.decision_types.keys.first
  end
end
