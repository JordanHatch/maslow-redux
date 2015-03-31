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
  validate :decision_id_is_present, if: -> { item_type == 'decision' }

  default_scope -> { order(created_at: :desc) }

  def data
    (attributes['data'] || {}).with_indifferent_access
  end

  def body
    data[:body]
  end

  def decision
    need.decisions.find(data[:decision_id])
  end

  def changes
    data[:changes]
  end

private

  def note_body_is_present
    errors.add(:body, 'is missing') unless data[:body].present?
  end

  def decision_id_is_present
    errors.add(:decision_id, 'is missing') unless data[:decision_id].present?
  end

end
