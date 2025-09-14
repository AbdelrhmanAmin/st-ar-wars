class SocialMedia::User < ApplicationRecord
    has_many :friendships, class_name: 'SocialMedia::UserFriendship', foreign_key: 'user_id'
    has_many :friends, through: :friendships, source: :friend, foreign_key: 'friend_id'

    def new
        @user = SocialMedia::User.new(full_name: full_name, age: age)
    end

    def create
       @user = SocialMedia::User.create(full_name: full_name, age: age)
       if @user.save
        return @user
       else
        return @user.errors
       end
    end

end
