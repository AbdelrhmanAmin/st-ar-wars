require 'rails_helper'

RSpec.describe SocialMedia::Post, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'associations' do
    it { should belong_to(:social_media_user).class_name('SocialMedia::User') }
  end

  describe 'instance methods' do
    let(:user) { create(:social_media_user, full_name: 'John Doe', age: 25) }
    let(:post) { build(:social_media_post, social_media_user: user, content: 'This is a test post') }
    
    it 'should be valid with valid attributes' do
      expect(post).to be_valid
    end

    it 'should be invalid without content' do
      post.content = nil
      expect(post).not_to be_valid
    end

    it 'should be invalid with empty content' do
      post.content = ''
      expect(post).not_to be_valid
    end

    it 'should be invalid without a user' do
      post.social_media_user = nil
      expect(post).not_to be_valid
    end

    it 'belongs to the correct user' do
      post.save!
      expect(post.social_media_user).to eq(user)
      expect(user.posts).to include(post)
    end

    it 'can have long content' do
      long_content = 'Lorem ipsum ' * 100
      post.content = long_content
      expect(post).to be_valid
    end
  end

  describe 'scopes' do
    let(:user1) { create(:social_media_user, full_name: 'User One', age: 25) }
    let(:user2) { create(:social_media_user, full_name: 'User Two', age: 30) }
    
    before do
      create(:social_media_post, social_media_user: user1, content: 'First post', created_at: 2.days.ago)
      create(:social_media_post, social_media_user: user1, content: 'Second post', created_at: 1.day.ago)
      create(:social_media_post, social_media_user: user2, content: 'Third post', created_at: Time.current)
    end

    it 'can filter posts by user' do
      expect(user1.posts.count).to eq(2)
      expect(user2.posts.count).to eq(1)
    end

    it 'orders posts by creation date by default' do
      all_posts = SocialMedia::Post.all.order(:created_at)
      expect(all_posts.first.content).to eq('First post')
      expect(all_posts.last.content).to eq('Third post')
    end
  end
end