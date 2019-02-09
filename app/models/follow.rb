class Follow < ApplicationRecord
  belongs_to :followable, polymorphic: true
  belongs_to :team
end
