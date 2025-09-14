class CreateSocialMediaUserFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :social_media_user_friendships do |t|
      t.references :user, null: false, foreign_key: { to_table: :social_media_users }
      t.references :friend, null: false, foreign_key: { to_table: :social_media_users }
      t.boolean :accepted, default: false
      t.timestamps
    end
    add_index :social_media_user_friendships, [:user_id, :friend_id], unique: true
    add_index :social_media_user_friendships, [:friend_id, :user_id], unique: true
  end
end
