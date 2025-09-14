class SocialMedia::UserFriendship < ApplicationRecord
    belongs_to :user, class_name: 'SocialMedia::User'
    belongs_to :friend, class_name: 'SocialMedia::User'

    validates :user_id, uniqueness: { scope: :friend_id }
    validate :user_and_friend_cannot_be_the_same
    validate :prevent_duplicate_friendships, on: :create

    private

    def user_and_friend_cannot_be_the_same
        if user_id == friend_id
            errors.add(:friend_id, "can't be the same as user")
        end
    end

    def prevent_duplicate_friendships
        if SocialMedia::UserFriendship.exists?(user_id: friend_id, friend_id: user_id)
            errors.add(:friend_id, "has already been taken")
        end
    end
end
