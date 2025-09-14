require 'rails_helper'

RSpec.describe SocialMedia::Event, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:date) }
  end

  describe 'associations' do
    it { should belong_to(:creator).class_name('SocialMedia::User') }
    it { should have_many(:event_attendees).class_name('SocialMedia::EventAttendee').with_foreign_key('social_media_event_id') }
    it { should have_many(:attendees).through(:event_attendees).source(:social_media_user) }
  end

  describe 'instance methods' do
    let(:creator) { create(:social_media_user, full_name: 'Event Creator', age: 28) }
    let(:event) { build(:social_media_event, creator: creator, title: 'Birthday Party', date: Date.tomorrow) }
    
    it 'should be valid with valid attributes' do
      expect(event).to be_valid
    end

    it 'should be invalid without a title' do
      event.title = nil
      expect(event).not_to be_valid
    end

    it 'should be invalid with empty title' do
      event.title = ''
      expect(event).not_to be_valid
    end

    it 'should be invalid without a date' do
      event.date = nil
      expect(event).not_to be_valid
    end

    it 'should be invalid without a creator' do
      event.creator = nil
      expect(event).not_to be_valid
    end

    it 'belongs to the correct creator' do
      event.save!
      expect(event.creator).to eq(creator)
      expect(creator.created_events).to include(event)
    end

    it 'can have a date in the past' do
      event.date = Date.yesterday
      expect(event).to be_valid
    end

    it 'can have a date in the future' do
      event.date = Date.tomorrow
      expect(event).to be_valid
    end

    it 'can have a date today' do
      event.date = Date.current
      expect(event).to be_valid
    end
  end

  describe 'attendee functionality' do
    let(:creator) { create(:social_media_user, full_name: 'Event Creator', age: 28) }
    let(:attendee1) { create(:social_media_user, full_name: 'Attendee One', age: 25) }
    let(:attendee2) { create(:social_media_user, full_name: 'Attendee Two', age: 30) }
    let(:event) { create(:social_media_event, creator: creator, title: 'Conference', date: Date.tomorrow) }

    it 'can have multiple attendees' do
      event.event_attendees.create(social_media_user: attendee1)
      event.event_attendees.create(social_media_user: attendee2)
      
      expect(event.attendees).to include(attendee1, attendee2)
      expect(event.attendees.count).to eq(2)
    end

    it 'attendees can access the event through their event_attendees' do
      event.event_attendees.create(social_media_user: attendee1)
      
      expect(attendee1.attended_events).to include(event)
    end

    it 'creator is not automatically an attendee' do
      expect(event.attendees).not_to include(creator)
    end

    it 'creator can also be an attendee if they register' do
      event.event_attendees.create(social_media_user: creator)
      expect(event.attendees).to include(creator)
    end
  end

  describe 'scopes and queries' do
    let(:creator1) { create(:social_media_user, full_name: 'Creator One', age: 25) }
    let(:creator2) { create(:social_media_user, full_name: 'Creator Two', age: 30) }
    
    before do
      create(:social_media_event, creator: creator1, title: 'Past Event', date: Date.yesterday)
      create(:social_media_event, creator: creator1, title: 'Today Event', date: Date.current)
      create(:social_media_event, creator: creator2, title: 'Future Event', date: Date.tomorrow)
    end

    it 'can filter events by creator' do
      expect(creator1.created_events.count).to eq(2)
      expect(creator2.created_events.count).to eq(1)
    end

    it 'can find events by date range' do
      future_events = SocialMedia::Event.where('date > ?', Date.current)
      expect(future_events.count).to eq(1)
      expect(future_events.first.title).to eq('Future Event')
    end
  end
end