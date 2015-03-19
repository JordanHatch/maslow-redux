class Decision < ActiveRecord::Base
  belongs_to :need

  validates :need, :decision_type, :outcome, presence: true
  validate :decision_type_and_outcome_exist

  scope :recent_first, -> { order(created_at: :desc) }
  scope :of_type, -> (type) { where(decision_type: type) }

  def self.decision_types
    {
      'scope' => [
        'in_scope',
        'out_of_scope',
      ],
      'completion' => [
        'incomplete',
        'complete',
      ],
      'met' => [
        'met',
        'not_met',
      ],
    }
  end

  def self.latest(type)
    of_type(type).recent_first.first
  end

private
  def decision_type_and_outcome_exist
    decision_types = self.class.decision_types

    if ! decision_types.has_key?(decision_type)
      errors.add(:decision_type, :is_unknown)
    elsif ! decision_types[decision_type].include?(outcome)
      errors.add(:outcome, :is_unknown)
    end
  end
end
