class ActivityItem < ActiveRecord::Base

  ITEM_TYPES = [
    'note',
    'decision',
    'create',
    'update',
    'response_new',
    'close',
    'reopen',
  ]

  belongs_to :need
  belongs_to :user

  validates :need, :user, :item_type, presence: true
  validates :item_type, inclusion: { in: ITEM_TYPES }

  validate :note_body_is_present, if: -> { item_type == 'note' }
  validate :decision_id_is_present, if: -> { item_type == 'decision' }
  validate :need_response_id_is_present, if: -> { item_type == 'response_new' }

  default_scope -> { order(created_at: :desc) }

  def data
    OpenStruct.new(attributes['data'] || {})
  end

  def body
    data.body
  end

  def decision
    need.decisions.find(data.decision_id)
  end

  def need_response
    need.need_responses.find(data.need_response_id)
  end

  def need_changes
    data.changes
  end

private

  def note_body_is_present
    errors.add(:body, 'is missing') unless data.body.present?
  end

  def decision_id_is_present
    errors.add(:decision_id, 'is missing') unless data.id.present?
  end

  def need_response_id_is_present
    errors.add(:need_response_id, 'is missing') unless data.id.present?
  end

end
