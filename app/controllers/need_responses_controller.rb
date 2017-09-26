class NeedResponsesController < ApplicationController
  before_action :check_if_need_can_be_edited!, except: :index

  layout 'skeleton'

  def index
  end

  def new
    authorize! :create, NeedResponse
  end

  def create
    authorize! :create, NeedResponse

    need_response.assign_attributes(need_response_params)

    if need_response.save_as(current_user)
      redirect_to need_responses_path(need)
    else
      render action: :new
    end
  end

  def edit
    authorize! :update, NeedResponse
  end

  def update
    authorize! :update, NeedResponse

    need_response.assign_attributes(need_response_params)

    if need_response.save_as(current_user)
      redirect_to need_responses_path(need)
    else
      render action: :edit
    end
  end

private
  def need
    authorize! :read, Need
    @need ||= Need.find(params[:need_id])
  end
  helper_method :need

  def need_response
    if params.key?(:id)
      @need_response ||= need.need_responses.find(params[:id])
    else
      @need_response ||= need.need_responses.build
    end
  end
  helper_method :need_response

  def need_response_params
    params.require(:need_response).permit(:response_type, :name, :url)
  end

  def check_if_need_can_be_edited!
    if need.present? && need.closed?
      flash.alert = 'Closed needs cannot be edited'
      redirect_to need_responses_path(need)
    end
  end
end
