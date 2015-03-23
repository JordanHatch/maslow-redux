class ActivityItem < ActiveRecord::Base

  ITEM_TYPES = [
    'note',
    'decision',
    'create',
    'update',
  ]

  belongs_to :need
  belongs_to :user

  validates :need, :user, :item_type, presence: true
  validates :item_type, inclusion: { in: ITEM_TYPES }
end
