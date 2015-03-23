class ConvertNotesToActivityItems < ActiveRecord::Migration
  def up
    Note.find_each do |note|
      ActivityItem.create!(
        need_id: note.need_id,
        user_id: note.author_id,
        item_type: 'note',
        data: {
          'body' => note.text,
        },
        created_at: note.created_at,
      )
      puts "Created activity item for Note ##{note.id} (Need ##{note.need_id}): \"#{note.text[0..30]}\""

      note.destroy
    end
  end

  def down
    ActivityItem.where(item_type: 'note').find_each do |item|
      Note.create!(
        need_id: item.need_id,
        author_id: item.user_id,
        text: item.data['body'],
        created_at: item.created_at,
      )
      puts "Created note for Item ##{item.id} (Need #{item.need_id}): \"#{item.data['body'][0..30]}\""

      item.destroy
    end
  end
end

class ActivityItem < ActiveRecord::Base
end

class Note < ActiveRecord::Base
end
