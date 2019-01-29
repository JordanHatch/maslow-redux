class TagType < ActiveRecord::Base

  before_validation :set_identifier, on: :create

  validates :name, :identifier, presence: true

  has_many :tags

  scope :index_pages, -> { where(show_index_page: true) }

private
  def set_identifier
    self.identifier ||= name.parameterize
  end

end
