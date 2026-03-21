# frozen_string_literal: true

RSpec.describe Legion::Extensions::GoogleCalendar::Runners::Events do
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

  describe '#list_events' do
    it 'returns events for a calendar' do
      stubs.get('/calendars/primary/events') do
        [200, { 'Content-Type' => 'application/json' },
         { 'kind' => 'calendar#events', 'items' => [{ 'id' => 'event1', 'summary' => 'Team Standup' }] }]
      end
      result = client.list_events(calendar_id: 'primary')
      expect(result[:events]).to be_a(Hash)
      expect(result[:events]['items'].first['id']).to eq('event1')
    end

    it 'passes time_min and time_max as query params' do
      stubs.get('/calendars/primary/events') do
        [200, { 'Content-Type' => 'application/json' },
         { 'kind' => 'calendar#events', 'items' => [] }]
      end
      result = client.list_events(
        calendar_id: 'primary',
        time_min:    '2026-03-01T00:00:00Z',
        time_max:    '2026-03-31T23:59:59Z'
      )
      expect(result[:events]['items']).to eq([])
    end
  end

  describe '#get_event' do
    it 'returns a single event by id' do
      stubs.get('/calendars/primary/events/event1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'id' => 'event1', 'summary' => 'Team Standup', 'status' => 'confirmed' }]
      end
      result = client.get_event(calendar_id: 'primary', event_id: 'event1')
      expect(result[:event]['id']).to eq('event1')
      expect(result[:event]['summary']).to eq('Team Standup')
    end
  end

  describe '#create_event' do
    it 'creates an event with required fields' do
      stubs.post('/calendars/primary/events') do
        [200, { 'Content-Type' => 'application/json' },
         { 'id' => 'newevent', 'summary' => 'Sprint Planning',
           'start' => { 'dateTime' => '2026-03-25T10:00:00Z' },
           'end'   => { 'dateTime' => '2026-03-25T11:00:00Z' } }]
      end
      result = client.create_event(
        calendar_id: 'primary',
        summary:     'Sprint Planning',
        start_time:  '2026-03-25T10:00:00Z',
        end_time:    '2026-03-25T11:00:00Z'
      )
      expect(result[:event]['id']).to eq('newevent')
      expect(result[:event]['summary']).to eq('Sprint Planning')
    end

    it 'creates an event with optional description and location' do
      stubs.post('/calendars/primary/events') do
        [200, { 'Content-Type' => 'application/json' },
         { 'id' => 'newevent2', 'summary' => 'All Hands', 'description' => 'Quarterly review',
           'location' => 'Conference Room A' }]
      end
      result = client.create_event(
        calendar_id: 'primary',
        summary:     'All Hands',
        start_time:  '2026-03-26T14:00:00Z',
        end_time:    '2026-03-26T15:00:00Z',
        description: 'Quarterly review',
        location:    'Conference Room A'
      )
      expect(result[:event]['location']).to eq('Conference Room A')
      expect(result[:event]['description']).to eq('Quarterly review')
    end
  end

  describe '#update_event' do
    it 'patches an event and returns updated event' do
      stubs.patch('/calendars/primary/events/event1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'id' => 'event1', 'summary' => 'Updated Standup' }]
      end
      result = client.update_event(calendar_id: 'primary', event_id: 'event1', summary: 'Updated Standup')
      expect(result[:event]['summary']).to eq('Updated Standup')
    end

    it 'patches start and end times when provided' do
      stubs.patch('/calendars/primary/events/event1') do
        [200, { 'Content-Type' => 'application/json' },
         { 'id' => 'event1', 'start' => { 'dateTime' => '2026-03-25T11:00:00Z' } }]
      end
      result = client.update_event(
        calendar_id: 'primary',
        event_id:    'event1',
        start_time:  '2026-03-25T11:00:00Z',
        end_time:    '2026-03-25T12:00:00Z'
      )
      expect(result[:event]['start']['dateTime']).to eq('2026-03-25T11:00:00Z')
    end
  end

  describe '#delete_event' do
    it 'returns deleted true on 204' do
      stubs.delete('/calendars/primary/events/event1') do
        [204, {}, nil]
      end
      result = client.delete_event(calendar_id: 'primary', event_id: 'event1')
      expect(result[:deleted]).to be true
      expect(result[:event_id]).to eq('event1')
    end

    it 'returns deleted false when status is not 204' do
      stubs.delete('/calendars/primary/events/missing') do
        [404, { 'Content-Type' => 'application/json' }, { 'error' => { 'code' => 404 } }]
      end
      result = client.delete_event(calendar_id: 'primary', event_id: 'missing')
      expect(result[:deleted]).to be false
      expect(result[:event_id]).to eq('missing')
    end
  end
end
