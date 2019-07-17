class NeedCriteriaController < ApplicationController

  def show
    authorize! :read, Need
  end

private
  def need
    @need ||= Need.find(params[:need_id])
  end
  helper_method :need

end
