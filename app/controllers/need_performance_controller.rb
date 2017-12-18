class NeedPerformanceController < ApplicationController

  def show
    authorize! :read, Need
  end

private
  helper_method :need, :presenter

  def need
    @need ||= Need.find(params[:need_id])
  end

  def performance_query
    @performance_query ||= NeedPerformanceQuery.new(
                              need.need_responses,
                              metric_type: :pageviews,
                              time_period: params.fetch(:period, :week).to_sym,
                              time_group: params.fetch(:group, :day).to_sym,
                            )
  end

  def presenter
    @presenter ||= NeedPerformancePresenter.new(performance_query)
  end

end
