class CreateSocialMediaPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :social_media_posts do |t|
      t.references :social_media_user, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
