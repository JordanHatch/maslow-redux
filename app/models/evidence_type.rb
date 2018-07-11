class EvidenceType < ApplicationRecord
  extend Enumerize

  enumerize :kind, in: [:quantitative, :qualitative]

  validates :name, :kind, presence: true
end
