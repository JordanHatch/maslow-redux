class NotesController < ApplicationController
  skip_authorization_check

  expose(:need)

  expose(:notes, model: :activity_item, ancestor: :need)
  expose(:note, model: :activity_item, ancestor: :notes)

  def create
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

    redirect_to need_activity_items_path(need)
  end
end
