# lex-google-calendar

LegionIO extension for Google Calendar integration via the Google Calendar REST API v3.

## Installation

Add to your Gemfile:

```ruby
gem 'lex-google-calendar'
```

## Standalone Usage

```ruby
require 'legion/extensions/google_calendar'

client = Legion::Extensions::GoogleCalendar::Client.new(token: 'your-oauth2-access-token')

# Calendars
client.list_calendars
client.get_calendar(calendar_id: 'primary')
client.create_calendar(summary: 'Team Calendar', time_zone: 'America/Chicago')

# Events
client.list_events(calendar_id: 'primary')
client.list_events(calendar_id: 'primary', time_min: '2026-03-01T00:00:00Z', time_max: '2026-03-31T23:59:59Z')
client.get_event(calendar_id: 'primary', event_id: 'event_id_here')
client.create_event(
  calendar_id: 'primary',
  summary:     'Team Standup',
  start_time:  '2026-03-25T10:00:00-06:00',
  end_time:    '2026-03-25T10:30:00-06:00',
  description: 'Daily sync',
  location:    'Conference Room A'
)
client.update_event(calendar_id: 'primary', event_id: 'event_id_here', summary: 'Updated Title')
client.delete_event(calendar_id: 'primary', event_id: 'event_id_here')
```

## Authentication

Google Calendar uses OAuth2 Bearer tokens. Obtain an access token via the Google OAuth2 flow with the `https://www.googleapis.com/auth/calendar` scope.

## License

MIT
