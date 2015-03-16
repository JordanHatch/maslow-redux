class Tag < ActiveRecord::Base
  belongs_to :tag_type

  validates :name, :tag_type, presence: true
end
