class NeedResponse < ApplicationRecord
  extend Enumerize

  enumerize :response_type, in: [:content, :service, :other]

  belongs_to :need

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
