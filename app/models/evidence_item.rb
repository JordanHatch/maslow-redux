class EvidenceItem < ApplicationRecord
  belongs_to :evidence_type
  belongs_to :need

  scope :of_type, ->(type) { find_or_initialize_by(evidence_type: type) }

  def quantitative?
    evidence_type.quantitative?
  end

  def qualitative?
    evidence_type.qualitative?
  end
end
