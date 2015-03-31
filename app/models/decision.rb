class Decision < ActiveRecord::Base
  attr_accessor :user

  belongs_to :need

  validates :need, :decision_type, :outcome, :user, presence: true
  validate :decision_type_and_outcome_exist

  after_create :create_activity_item

  scope :recent_first, -> { order(created_at: :desc) }
  scope :of_type, -> (type) { where(decision_type: type) }

  def self.decision_types
    {
      'scope' => {
        'in_scope' => 'green',
        'out_of_scope' => 'red',
      },
      'completion' => {
        'incomplete' => 'red',
        'complete' => 'green',
      },
      'met' => {
        'met' => 'green',
        'not_met' => 'red',
      },
    }
  end

  def self.decision_type_outcomes(decision_type)
    decision_types[decision_type].keys
  end

  def self.latest(type)
    of_type(type).recent_first.first
  end

  def colour
    self.class.decision_types.fetch(decision_type).fetch(outcome)
  end

private
  def decision_type_and_outcome_exist
    decision_types = self.class.decision_types

    if ! decision_types.has_key?(decision_type)
      errors.add(:decision_type, :is_unknown)
    elsif ! decision_types[decision_type].keys.include?(outcome)
      errors.add(:outcome, :is_unknown)
    end
  end

  def create_activity_item
    need.activity_items.create!(
      item_type: 'decision',
      user: user,
      data: {
        decision_id: self.id,
        body: note,
      },
    )
  end
end
