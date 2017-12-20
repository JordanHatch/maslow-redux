class NeedsController < ApplicationController
  include Concerns::Filterable

  class Http404 < StandardError
  end

  rescue_from Http404 do
    render "public/404", :status => 404
  end

  def index
    authorize! :index, Need

    @bookmarks = current_user.bookmarks
    @current_page = needs_path

    respond_to do |format|
      format.html
      format.json {
        render json: { status: :ok, needs: needs }, status: :ok
      }
      format.csv do
        send_data NeedsCsvPresenter.new(needs_url, needs).to_csv,
                  filename: "#{params["organisation_id"]}.csv",
                  type: "text/csv; charset=utf-8"
      end
    end
  end

  def show
    authorize! :read, Need
  end

  def activity
    authorize! :read, Need
  end

  def evidence
    authorize! :read, Need
  end

  def edit
    authorize! :update, Need
    @need = load_need
    if @need.duplicate?
      redirect_to need_url(@need.need_id),
                  alert: "Closed needs cannot be edited",
                  status: 303
      return
    end
  end

  def new
    authorize! :create, Need
    @need = Need.new({})
  end

  def create
    authorize! :create, Need

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

    need.assign_attributes(need_params)
    add_or_remove_criteria(:edit) and return if criteria_params_present?

    if need.save_as(current_user)
      redirect_to redirect_url, notice: "Need updated",
        flash: { need_id: need.need_id, goal: need.goal }
    else
      render :edit, status: 422
    end
  end

  def close_as_duplicate
    authorize! :close, Need

    if need.closed?
      redirect_to need_url(need),
                  alert: "This need is already closed",
                  status: 303
      return
    end
  end

  def closed
    authorize! :close, Need

    need.canonical_need_id = params[:need][:canonical_need_id].to_i

    if need.save_as(current_user)
      redirect_to need_url(need.need_id)
    else
      render :close_as_duplicate, :status => 422
    end
  end

  def reopen
    authorize! :reopen, Need

    if need.reopen_as(current_user)
      redirect_to need_url(need.need_id), notice: "Need re-opened"
    else
      flash[:error] = "There was a problem reopening the need"
      render :show, status: 422
    end
  end

private

  def needs
    @needs ||= filtered_needs.all
  end
  helper_method :needs

  def needs_with_pagination
    @needs_with_pagination ||= needs.page(params[:page])
  end
  helper_method :needs_with_pagination

  def need
    if params.key?(:id)
      @need ||= Need.find_by_need_id(params[:id])
    else
      @need ||= Need.new
    end
  end
  helper_method :need

  def redirect_url
    params["add_new"] ? new_need_path : need_url(need.need_id)
  end

  def prepare_need_params
    need_params.tap {|hash|
      [:met_when].each do |field|
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
      :legislation, { met_when: [] }
    ).tap do |whitelisted|
      permit_fields_for_tags!(whitelisted)
    end
  end

  def permit_fields_for_tags!(whitelisted)
    TagType.all.each do |tag_type|
      key = "tag_ids_of_type_#{tag_type.id}"
      whitelisted[key] = params[:need][key]
    end
  end
end
