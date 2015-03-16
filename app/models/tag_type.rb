class TagType < ActiveRecord::Base

  before_validation :set_identifier, on: :create

  validates :name, :identifier, presence: true

  has_many :tags

private
  def set_identifier
    self.identifier ||= name.parameterize
  end

end
