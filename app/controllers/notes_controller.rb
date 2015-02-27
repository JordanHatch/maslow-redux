require 'gds_api/need_api'
require 'plek'
require 'json'

class NotesController < ApplicationController
  def create
    authorize! :create, Note

    @need = Need.find_by_need_id(params[:need_id])
    @note = Note.new(
      text: params[:notes][:text],
      need_id: @need.need_id,
      author: current_user,
    )

    if @note.save
      flash[:notice] = "Note saved"
    else
      flash[:error] = "Note couldn't be saved: #{@note.errors.messages}"
    end
    redirect_to revisions_need_path(@need)
  end
end
