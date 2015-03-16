require 'json'

class NeedsController < ApplicationController
  skip_authorization_check

  expose(:need)

  class Http404 < StandardError
  end

  rescue_from Http404 do
    render "public/404", :status => 404
  end

  def index
    authorize! :index, Need
    opts = params.slice("organisation_id", "page", "q").select { |k, v| v.present? }

    @bookmarks = current_user.bookmarks
    @current_page = needs_path

    @needs = Need.page(params[:page])

    respond_to do |format|
      format.html
      format.csv do
        send_data NeedsCsvPresenter.new(needs_url, @needs).to_csv,
                  filename: "#{params["organisation_id"]}.csv",
                  type: "text/csv; charset=utf-8"
      end
    end
  end

  def show
    authorize! :read, Need
    @need = load_need
  end

  def actions
    authorize! :perform_actions_on, Need
    @need = load_need
  end

  def revisions
    authorize! :see_revisions_of, Need
    @need = load_need
  end

  def edit
    authorize! :update, Need
    @need = load_need
    if @need.duplicate?
      redirect_to need_url(@need.need_id),
                  notice: "Closed needs cannot be edited",
                  status: 303
      return
    end
  end

  def new
    authorize! :create, Need
    @need = Need.new({})
  end

  def create
    need.assign_attributes(need_params)
    add_or_remove_criteria(:new) and return if criteria_params_present?

    if need.save_as(current_user)
      redirect_to redirect_url, notice: "Need created",
        flash: { need_id: need.need_id, goal: need.goal }
    else
      render :new, status: 422
    end
  end

  def update
    authorize! :update, Need

    @need = load_need
    @need.assign_attributes(prepare_need_params)

    add_or_remove_criteria(:edit) and return if criteria_params_present?

    if @need.save_as(current_user)
      redirect_to redirect_url, notice: "Need updated",
        flash: { need_id: @need.need_id, goal: @need.goal }
    else
      flash[:error] = "There were errors in the need form."
      render "edit", :status => 422
    end
  end

  def close_as_duplicate
    authorize! :close, Need
    @need = load_need
    if @need.duplicate?
      redirect_to need_url(@need.need_id),
                  notice: "This need is already closed",
                  status: 303
      return
    end
  end

  def closed
    authorize! :close, Need

    @need = load_need
    @need.duplicate_of = params["need"]["duplicate_of"].to_i

    @canonical_need = Need.find_by_need_id(@need.duplicate_of)

    if @need.valid? && @canonical_need.present?
      if @need.save_as(current_user)
        redirect_to need_url(@need.need_id), notice: "Need closed as a duplicate of",
          flash: { need_id: @canonical_need.need_id, goal: @canonical_need.goal }
        return
      else
        flash[:error] = "There was a problem closing the need as a duplicate"
      end
    else
      flash[:error] = "The Need ID entered is invalid"
    end

    @need.duplicate_of = nil
    render "actions", :status => 422
  end

  def reopen
    authorize! :reopen, Need

    @need = load_need
    old_canonical_id = @need.duplicate_of

    if @need.reopen_as(current_user)
      redirect_to need_url(@need.need_id), notice: "Need is no longer a duplicate of",
        flash: { need_id: old_canonical_id, goal: Need.find_by_need_id(old_canonical_id).goal }
      return
    else
      flash[:error] = "There was a problem reopening the need"
    end

    render "show", :status => 422
  end

  def status
    authorize! :validate, Need
    @need = load_need
  end

  def update_status
    authorize! :validate, Need
    @need = load_need

    status_params = params["need"]["status"]

    reasons = [
      status_params["common_reasons_why_invalid"],
      status_params["other_reasons_why_invalid"]
    ].flatten.select(&:present?)

    need_status = NeedStatus.new(
      description: status_params["description"],
      reasons: reasons,
      additional_comments: status_params["additional_comments"],
      validation_conditions: status_params["validation_conditions"],
    )

    unless need_status.valid?
      flash[:error] = need_status.errors.full_messages.join(". ")
      redirect_to need_path(@need)
      return
    end

    @need.status = need_status

    unless @need.save_as(current_user)
      flash[:error] = "We had a problem updating the need’s status"
    end

    redirect_to need_path(@need)
  end

private

  def redirect_url
    params["add_new"] ? new_need_path : need_url(need.need_id)
  end

  def prepare_need_params
    need_params.tap {|hash|
      [:organisation_ids, :met_when].each do |field|
        if hash[field]
          hash[field].select!(&:present?)
        end
      end
    }
  end

  def load_need
    begin
      Need.find_by_need_id(params[:id])
    rescue ArgumentError, TypeError # shouldn't happen; route is constrained
      raise Http404
    end
  end

  def criteria_params_present?
    params[:criteria_action].present? || params[:delete_criteria].present?
  end

  def add_or_remove_criteria(action)
    add_criteria if params[:criteria_action]
    remove_criteria if params[:delete_criteria]
    render :action => action
  end

  def add_criteria
    need.add_more_criteria
  end

  def remove_criteria
    index = Integer(params[:delete_criteria])
    need.remove_criteria(index)
  rescue ArgumentError
  end

  def need_params
    params.require(:need).permit(:role, :goal, :benefit, :yearly_user_contacts,
      :yearly_site_views, :yearly_need_views, :yearly_searches, :other_evidence,
      :legislation, :applies_to_all_organisations,
      { organisation_ids: [] }, { met_when: [] })
  end
end
