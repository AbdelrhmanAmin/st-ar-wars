require 'rails_helper'

RSpec.describe SocialMedia::User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age).is_greater_than(0) }
  end

  describe 'associations' do
    # Posts
    it { should have_many(:posts).class_name('SocialMedia::Post').with_foreign_key('social_media_user_id') }
    
    # Events
    it { should have_many(:created_events).class_name('SocialMedia::Event').with_foreign_key('creator_id') }
    it { should have_many(:event_attendees).class_name('SocialMedia::EventAttendee').with_foreign_key('social_media_user_id') }
    it { should have_many(:attended_events).through(:event_attendees).source(:social_media_event) }
    
    # Friendships
    it { should have_many(:friendships).class_name('SocialMedia::UserFriendship').with_foreign_key('user_id') }
    it { should have_many(:friends).through(:friendships).source(:friend) }
    it { should have_many(:incoming_friendships).class_name('SocialMedia::UserFriendship').with_foreign_key('friend_id') }
    it { should have_many(:friend_requests).through(:incoming_friendships).source(:user) }
  end

  # describe 'instance methods' do
  #   let(:user) { create(:social_media_user, full_name: 'John Doe', age: 25) }
  #   let(:friend) { create(:social_media_user, full_name: 'Jane Smith', age: 23) }
    
  #   it 'should be valid with valid attributes' do
  #     expect(user).to be_valid
  #   end

  #   it 'should be invalid without full_name' do
  #     user.full_name = nil
  #     expect(user).not_to be_valid
  #   end

  #   it 'should be invalid without age' do
  #     user.age = nil
  #     expect(user).not_to be_valid
  #   end

  #   it 'should be invalid with age less than or equal to 0' do
  #     user.age = 0
  #     expect(user).not_to be_valid
      
  #     user.age = -5
  #     expect(user).not_to be_valid
  #   end

  #   describe 'friendship functionality' do
  #     it 'can create friendships' do
  #       friendship = user.friendships.create(friend: friend, accepted: true)
  #       expect(user.friends).to include(friend)
  #     end

  #     it 'can receive friend requests' do
  #       friendship = friend.friendships.create(friend: user, accepted: false)
  #       expect(user.friend_requests).to include(friend)
  #     end
  #   end

  #   describe 'event functionality' do
  #     let(:event) { user.created_events.create(title: 'Birthday Party', date: Date.tomorrow) }
      
  #     it 'can create events' do
  #       expect(user.created_events).to include(event)
  #     end

  #     it 'can attend events' do
  #       other_user_event = friend.created_events.create(title: 'Wedding', date: Date.tomorrow)
  #       user.event_attendees.create(social_media_event: other_user_event)
  #       expect(user.attended_events).to include(other_user_event)
  #     end
  #   end

  #   describe 'post functionality' do
  #     it 'can create posts' do
  #       post = user.posts.create(content: 'Hello, world!')
  #       expect(user.posts).to include(post)
  #     end
  #   end
  # end
end