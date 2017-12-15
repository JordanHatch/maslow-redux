class NeedResponse < ApplicationRecord
  extend Enumerize

  enumerize :response_type, in: [:content, :service, :other]

  validates :need, :response_type, :name, presence: true

  belongs_to :need
  has_many :performance_points, class_name: 'NeedPerformancePoint', dependent: :destroy

  def save_as(user)
    if new_record?
      save && create_activity_item(user)
    else
      save
    end
  end

private
  def create_activity_item(user)
    need.activity_items.create!(
      item_type: 'response_new',
      user: user,
      data: {
        need_response_id: self.id
      },
    )
  end
end
