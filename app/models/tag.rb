class Tag < ActiveRecord::Base
  include Concerns::Followable

  belongs_to :tag_type
  validates :name, :tag_type, presence: true

  has_many :taggings, dependent: :destroy
  has_many :needs, through: :taggings

  scope :of_type, -> (type) { where(tag_type: type) }
  scope :with_pages, ->{ where(tag_type: TagType.index_pages) }

  before_validation :remove_blank_priority_need_ids

  def tag_type_identifier
    tag_type.identifier
  end

  def remove_blank_priority_need_ids
    if priority_need_ids
      priority_need_ids.delete_if(&:nil?)
    end
  end
end
