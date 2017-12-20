class PropositionStatement < ApplicationRecord
  has_and_belongs_to_many :needs

  validates :name, presence: true

  default_scope -> { order('name ASC') }
end
