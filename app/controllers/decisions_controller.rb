class DecisionsController < ApplicationController
  expose(:need)
  expose(:decisions, ancestor: :need) {
    need.decisions.recent_first
  }
  expose(:decision)

  skip_authorization_check

  def new
    decision.decision_type ||= default_decision_type
  end

  def create
    decision.assign_attributes(decision_params)
    decision.user = current_user

    if decision.save
      redirect_to need_activity_items_path(need)
    else
      render action: :new
    end
  end

private
  def decision_params
    params.require(:decision).permit(:decision_type, :outcome, :note)
  end

  def default_decision_type
    params[:decision_type] || Decision.decision_types.keys.first
  end
end
