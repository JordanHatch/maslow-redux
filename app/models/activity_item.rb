class ActivityItem < ActiveRecord::Base

  ITEM_TYPES = [
    'note',
    'decision',
    'create',
    'update',
  ]

  belongs_to :need
  belongs_to :user

  validates :need, :user, :item_type, presence: true
  validates :item_type, inclusion: { in: ITEM_TYPES }

  validate :note_body_is_present, if: -> { item_type == 'note' }

  default_scope -> { order(created_at: :desc) }

  def data
    (attributes['data'] || {}).with_indifferent_access
  end

  def body
    data[:body]
  end

  def changes
    data[:changes]
  end

private

  def note_body_is_present
    errors.add(:body, 'is missing') unless data[:body].present?
  end

end
