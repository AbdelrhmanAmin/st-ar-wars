require 'rails_helper'

RSpec.describe SocialMedia::UserFriendship, type: :model do
  describe 'associations' do
    it { should belong_to(:user).class_name('SocialMedia::User') }
    it { should belong_to(:friend).class_name('SocialMedia::User') }
  end

  describe 'validations' do
    let(:user1) { SocialMedia::User.create!(full_name: 'John Doe', age: 25) }
    let(:user2) { SocialMedia::User.create!(full_name: 'Jane Smith', age: 28) }
    
    it 'should be valid with valid attributes' do
      friendship = SocialMedia::UserFriendship.new(user: user1, friend: user2, accepted: false)
      expect(friendship).to be_valid
    end

    it 'should be invalid without a user' do
      friendship = SocialMedia::UserFriendship.new(friend: user2, accepted: false)
      expect(friendship).not_to be_valid
    end

    it 'should be invalid without a friend' do
      friendship = SocialMedia::UserFriendship.new(user: user1, accepted: false)
      expect(friendship).not_to be_valid
    end

    it 'should prevent duplicate friendships' do
      # Create the first friendship
      SocialMedia::UserFriendship.create!(user: user1, friend: user2, accepted: true)
      
      # Try to create a duplicate
      duplicate_friendship = SocialMedia::UserFriendship.new(user: user1, friend: user2, accepted: false)
      expect(duplicate_friendship).not_to be_valid
      expect(duplicate_friendship.errors[:user_id]).to include('has already been taken')
    end

    it 'should prevent reverse duplicate friendships' do
      # Create the first friendship
      SocialMedia::UserFriendship.create!(user: user1, friend: user2, accepted: true)
      
      # Try to create the reverse friendship
      reverse_friendship = SocialMedia::UserFriendship.new(user: user2, friend: user1, accepted: false)
      expect(reverse_friendship).not_to be_valid
      expect(reverse_friendship.errors[:friend_id]).to include('has already been taken')
    end

    it 'should prevent users from friending themselves' do
      self_friendship = SocialMedia::UserFriendship.new(user: user1, friend: user1, accepted: false)
      expect(self_friendship).not_to be_valid
      expect(self_friendship.errors[:friend_id]).to include("can't be the same as user")
    end
  end

  # describe 'default values' do
  #   let(:user1) { create(:social_media_user, full_name: 'John Doe', age: 25) }
  #   let(:user2) { create(:social_media_user, full_name: 'Jane Smith', age: 28) }

  #   it 'defaults accepted to false' do
  #     friendship = SocialMedia::UserFriendship.create!(user: user1, friend: user2)
  #     expect(friendship.accepted).to be false
  #   end
  # end

  # describe 'functionality' do
  #   let(:user1) { create(:social_media_user, full_name: 'John Doe', age: 25) }
  #   let(:user2) { create(:social_media_user, full_name: 'Jane Smith', age: 28) }
  #   let(:user3) { create(:social_media_user, full_name: 'Bob Wilson', age: 30) }

  #   describe 'friend requests' do
  #     it 'creates a pending friend request' do
  #       friendship = SocialMedia::UserFriendship.create!(user: user1, friend: user2, accepted: false)
        
  #       expect(user1.friendships).to include(friendship)
  #       expect(user1.friends).to be_empty  # Not accepted yet
  #       expect(user2.friend_requests).to include(user1)
  #     end

  #     it 'can accept a friend request' do
  #       friendship = SocialMedia::UserFriendship.create!(user: user1, friend: user2, accepted: false)
  #       friendship.update!(accepted: true)
        
  #       expect(user1.friends).to include(user2)
  #       expect(friendship.accepted).to be true
  #     end

  #     it 'can reject a friend request by deleting it' do
  #       friendship = SocialMedia::UserFriendship.create!(user: user1, friend: user2, accepted: false)
  #       friendship.destroy!
        
  #       expect(user1.friendships).to be_empty
  #       expect(user2.friend_requests).to be_empty
  #     end
  #   end

  #   describe 'accepted friendships' do
  #     before do
  #       SocialMedia::UserFriendship.create!(user: user1, friend: user2, accepted: true)
  #       SocialMedia::UserFriendship.create!(user: user1, friend: user3, accepted: true)
  #     end

  #     it 'shows friends for the user who initiated' do
  #       expect(user1.friends).to include(user2, user3)
  #       expect(user1.friends.count).to eq(2)
  #     end

  #     it 'does not automatically create reverse friendship' do
  #       expect(user2.friends).to be_empty
  #       expect(user3.friends).to be_empty
  #     end

  #     it 'allows bidirectional friendships with separate records' do
  #       # user2 friends user1 back
  #       SocialMedia::UserFriendship.create!(user: user2, friend: user1, accepted: true)
        
  #       expect(user1.friends).to include(user2)
  #       expect(user2.friends).to include(user1)
  #     end
  #   end

  #   describe 'friendship states' do
  #     it 'can track pending friendships' do
  #       pending_friendship = SocialMedia::UserFriendship.create!(user: user1, friend: user2, accepted: false)
  #       accepted_friendship = SocialMedia::UserFriendship.create!(user: user1, friend: user3, accepted: true)
        
  #       pending_friendships = user1.friendships.where(accepted: false)
  #       accepted_friendships = user1.friendships.where(accepted: true)
        
  #       expect(pending_friendships).to include(pending_friendship)
  #       expect(accepted_friendships).to include(accepted_friendship)
  #     end
  #   end

  #   describe 'friendship removal' do
  #     it 'can unfriend by destroying the friendship' do
  #       friendship = SocialMedia::UserFriendship.create!(user: user1, friend: user2, accepted: true)
        
  #       expect(user1.friends).to include(user2)
        
  #       friendship.destroy!
        
  #       expect(user1.reload.friends).not_to include(user2)
  #     end
  #   end
  # end

  describe 'scopes and queries' do
    let(:user1) { SocialMedia::User.create!(full_name: 'John Doe', age: 25) }
    let(:user2) { SocialMedia::User.create!(full_name: 'Jane Smith', age: 28) }
    let(:user3) { SocialMedia::User.create!(full_name: 'Bob Wilson', age: 30) }
    let(:user4) { SocialMedia::User.create!(full_name: 'Alice Brown', age: 26) }
    let(:user5) { SocialMedia::User.create!(full_name: 'User Five', age: 29) }
    before do
      # Accepted friendships
      SocialMedia::UserFriendship.create!(user: user1, friend: user2, accepted: true)
      SocialMedia::UserFriendship.create!(user: user1, friend: user3, accepted: true)
      
      # Pending friendship
      SocialMedia::UserFriendship.create!(user: user1, friend: user4, accepted: false)
      
      # Incoming friend request
      SocialMedia::UserFriendship.create!(user: user5, friend: user1, accepted: false)
    end

    it 'can find accepted friendships' do
      accepted = SocialMedia::UserFriendship.where(user: user1, accepted: true)
      expect(accepted.count).to eq(2)
      expect(accepted.map(&:friend)).to include(user2, user3)
    end

    it 'can find pending outgoing requests' do
      pending = SocialMedia::UserFriendship.where(user: user1, accepted: false)
      expect(pending.count).to eq(1)
      expect(pending.first.friend).to eq(user4)
    end

    it 'can find incoming friend requests' do
      incoming = SocialMedia::UserFriendship.where(friend: user1, accepted: false)
      expect(incoming.count).to eq(1)
      expect(incoming.first.user.full_name).to eq('User Five')
    end
  end
end