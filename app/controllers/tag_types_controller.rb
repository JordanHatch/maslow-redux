class TagTypesController < ApplicationController
  def show
    authorize! :show, tag_type
  end

private
  def tag_type
    @tag_type ||= TagType.index_pages.find_by_identifier(params[:id])
  end
  helper_method :tag_type
end
