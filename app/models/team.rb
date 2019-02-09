class Team < ApplicationRecord
  has_and_belongs_to_many :users
  validates :name, presence: true

  has_many :follows
  
  has_many :needs, through: :follows, source: :followable, source_type: 'Need'
  has_many :tags, through: :follows, source: :followable, source_type: 'Tag'
end
