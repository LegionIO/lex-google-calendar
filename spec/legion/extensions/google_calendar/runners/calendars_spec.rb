# frozen_string_literal: true

RSpec.describe Legion::Extensions::GoogleCalendar::Runners::Calendars do
  let(:client) { Legion::Extensions::GoogleCalendar::Client.new(token: 'ya29.test-token') }

  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:test_connection) do
    Faraday.new(url: 'https://www.googleapis.com/calendar/v3') do |conn|
      conn.request :json
      conn.response :json, content_type: /\bjson$/
      conn.adapter :test, stubs
    end
  end

  before { allow(client).to receive(:connection).and_return(test_connection) }

  describe '#list_calendars' do
    it 'returns a list of calendars' do
      stubs.get('/users/me/calendarList') do
        [200, { 'Content-Type' => 'application/json' },
         { 'kind' => 'calendar#calendarList', 'items' => [{ 'id' => 'primary', 'summary' => 'My Calendar' }] }]
      end
      result = client.list_calendars
      expect(result[:calendars]).to be_a(Hash)
      expect(result[:calendars]['items'].first['id']).to eq('primary')
    end
  end

  describe '#get_calendar' do
    it 'returns a single calendar by id' do
      stubs.get('/calendars/primary') do
        [200, { 'Content-Type' => 'application/json' },
         { 'id' => 'primary', 'summary' => 'My Calendar', 'timeZone' => 'America/Chicago' }]
      end
      result = client.get_calendar(calendar_id: 'primary')
      expect(result[:calendar]['id']).to eq('primary')
      expect(result[:calendar]['summary']).to eq('My Calendar')
    end
  end

  describe '#create_calendar' do
    it 'creates a calendar with summary and returns it' do
      stubs.post('/calendars') do
        [200, { 'Content-Type' => 'application/json' },
         { 'id' => 'newcal@group.calendar.google.com', 'summary' => 'Team Calendar' }]
      end
      result = client.create_calendar(summary: 'Team Calendar')
      expect(result[:calendar]['id']).to eq('newcal@group.calendar.google.com')
      expect(result[:calendar]['summary']).to eq('Team Calendar')
    end

    it 'includes optional description and time_zone when provided' do
      stubs.post('/calendars') do
        [200, { 'Content-Type' => 'application/json' },
         { 'id' => 'newcal@group.calendar.google.com', 'summary' => 'Team Calendar',
           'description' => 'For the team', 'timeZone' => 'America/Chicago' }]
      end
      result = client.create_calendar(
        summary:     'Team Calendar',
        description: 'For the team',
        time_zone:   'America/Chicago'
      )
      expect(result[:calendar]['timeZone']).to eq('America/Chicago')
    end
  end
end
