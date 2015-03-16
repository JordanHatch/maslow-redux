class Tag < ActiveRecord::Base
  belongs_to :tag_type
  validates :name, :tag_type, presence: true

  has_many :taggings, dependent: :destroy
  has_many :needs, through: :taggings

  scope :of_type, -> (type) { where(tag_type: type) }
end
