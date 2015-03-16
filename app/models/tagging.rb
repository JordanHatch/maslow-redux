class Tagging < ActiveRecord::Base
  belongs_to :need
  belongs_to :tag

  validates :need, :tag, presence: true
end
