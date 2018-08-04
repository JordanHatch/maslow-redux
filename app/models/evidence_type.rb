class EvidenceType < ApplicationRecord
  extend Enumerize

  enumerize :kind, in: [:quantitative, :qualitative]

  has_many :evidence_items, dependent: :destroy

  scope :quantitative, ->{ where(kind: :quantitative) }
  scope :qualitative, ->{ where(kind: :qualitative) }

  validates :name, :kind, presence: true

  def quantitative?
    kind == :quantitative
  end

  def qualitative?
    kind == :qualitative
  end
end
