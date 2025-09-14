class CreateSocialMediaEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :social_media_events do |t|
      t.string :title
      t.date :date
      t.references :creator, null: false, foreign_key: { to_table: :social_media_users }
      t.timestamps
    end
  end
end
