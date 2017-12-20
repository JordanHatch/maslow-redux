class NeedPerformancePointsController < ApplicationController

  def show
    authorize! :read, NeedPerformancePoint

    respond_to do |format|
      if performance_point.persisted?
        format.json
      else
        format.json {
          render json: { status: :not_found }, status: :not_found
        }
      end
    end
  end

  def update
    authorize! :update, NeedPerformancePoint

    performance_point.value = params[:value]

    respond_to do |format|
      if performance_point.save
        format.json {
          render json: { status: :ok, need_performance_point: performance_point }, status: :ok
        }
      else
        format.json {
          render json: { status: :unprocessable_entity, errors: performance_point.errors }, status: :unprocessable_entity
        }
      end
    end
  end

private
  helper_method :need, :need_response, :performance_point

  def need
    @need ||= Need.find(params[:need_id])
  end

  def need_response
    @need_response ||= need.need_responses.find(params[:id])
  end

  def performance_point
    @performance_point ||= need_response.performance_points.for_metric(params[:metric_type])
                                                             .for_date(params[:date])
                                                             .first_or_initialize
  end

end
