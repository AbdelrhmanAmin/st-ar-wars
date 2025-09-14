class CreateSocialMediaEventAttendees < ActiveRecord::Migration[6.1]
  def change
    create_table :social_media_event_attendees do |t|
      t.references :social_media_event, null: false, foreign_key: true
      t.references :social_media_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
