require 'rails_helper'

RSpec.describe SocialMedia::EventAttendee, type: :model do
  describe 'associations' do
    it { should belong_to(:social_media_event).class_name('SocialMedia::Event') }
    it { should belong_to(:social_media_user).class_name('SocialMedia::User') }
  end

  describe 'validations' do
    let(:user) { create(:social_media_user, full_name: 'John Doe', age: 25) }
    let(:event) { create(:social_media_event, creator: user, title: 'Test Event', date: Date.tomorrow) }
    
    it 'should be valid with valid attributes' do
      attendee = SocialMedia::EventAttendee.new(social_media_user: user, social_media_event: event)
      expect(attendee).to be_valid
    end

    it 'should be invalid without a user' do
      attendee = SocialMedia::EventAttendee.new(social_media_event: event)
      expect(attendee).not_to be_valid
    end

    it 'should be invalid without an event' do
      attendee = SocialMedia::EventAttendee.new(social_media_user: user)
      expect(attendee).not_to be_valid
    end

    it 'should prevent duplicate attendees for the same event' do
      # This test assumes you'll add a uniqueness validation
      SocialMedia::EventAttendee.create!(social_media_user: user, social_media_event: event)
      duplicate_attendee = SocialMedia::EventAttendee.new(social_media_user: user, social_media_event: event)
      expect(duplicate_attendee).not_to be_valid
      expect(duplicate_attendee.errors[:social_media_user_id]).to include('has already been taken')
    end
  end

  describe 'functionality' do
    let(:creator) { create(:social_media_user, full_name: 'Event Creator', age: 30) }
    let(:attendee1) { create(:social_media_user, full_name: 'Attendee One', age: 25) }
    let(:attendee2) { create(:social_media_user, full_name: 'Attendee Two', age: 28) }
    let(:event) { create(:social_media_event, creator: creator, title: 'Workshop', date: Date.tomorrow) }

    it 'connects users and events properly' do
      event_attendee = SocialMedia::EventAttendee.create!(
        social_media_user: attendee1,
        social_media_event: event
      )

      expect(event_attendee.social_media_user).to eq(attendee1)
      expect(event_attendee.social_media_event).to eq(event)
      expect(event.attendees).to include(attendee1)
      expect(attendee1.attended_events).to include(event)
    end

    it 'allows multiple attendees for one event' do
      SocialMedia::EventAttendee.create!(social_media_user: attendee1, social_media_event: event)
      SocialMedia::EventAttendee.create!(social_media_user: attendee2, social_media_event: event)

      expect(event.attendees).to include(attendee1, attendee2)
      expect(event.attendees.count).to eq(2)
    end

    it 'allows one user to attend multiple events' do
      event2 = create(:social_media_event, creator: creator, title: 'Conference', date: Date.tomorrow + 1.week)
      
      SocialMedia::EventAttendee.create!(social_media_user: attendee1, social_media_event: event)
      SocialMedia::EventAttendee.create!(social_media_user: attendee1, social_media_event: event2)

      expect(attendee1.attended_events).to include(event, event2)
      expect(attendee1.attended_events.count).to eq(2)
    end

    it 'can be destroyed to remove attendance' do
      event_attendee = SocialMedia::EventAttendee.create!(
        social_media_user: attendee1,
        social_media_event: event
      )

      expect(event.attendees).to include(attendee1)
      
      event_attendee.destroy!
      
      expect(event.reload.attendees).not_to include(attendee1)
      expect(attendee1.reload.attended_events).not_to include(event)
    end
  end

  describe 'timestamps' do
    let(:user) { create(:social_media_user, full_name: 'John Doe', age: 25) }
    let(:event) { create(:social_media_event, creator: user, title: 'Test Event', date: Date.tomorrow) }

    it 'records when the attendance was created' do
      attendee = SocialMedia::EventAttendee.create!(
        social_media_user: user,
        social_media_event: event
      )

      expect(attendee.created_at).to be_present
      expect(attendee.updated_at).to be_present
      expect(attendee.created_at).to be_within(1.second).of(Time.current)
    end
  end

  describe 'dependent destroys' do
    let(:user) { create(:social_media_user, full_name: 'John Doe', age: 25) }
    let(:event) { create(:social_media_event, creator: user, title: 'Test Event', date: Date.tomorrow) }
    let!(:event_attendee) { SocialMedia::EventAttendee.create!(social_media_user: user, social_media_event: event) }

    it 'should be destroyed when the user is destroyed' do
      expect { user.destroy! }.to change { SocialMedia::EventAttendee.count }.by(-1)
    end

    it 'should be destroyed when the event is destroyed' do
      expect { event.destroy! }.to change { SocialMedia::EventAttendee.count }.by(-1)
    end
  end
end