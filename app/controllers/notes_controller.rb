class NotesController < ApplicationController

  def create
    authorize! :create, :note

    note.assign_attributes(
      item_type: 'note',
      user: current_user,
      data: {
        body: params[:note][:body]
      }
    )

    if note.save
      flash.notice = "Note saved"
    else
      flash.alert = "Note must not be blank"
    end

    redirect_to need_path(need)
  end

private
  def need
    @need ||= Need.find(params[:need_id])
  end
  helper_method :need

  def note
    @note ||= need.activity_items.build
  end
  helper_method :note
end
