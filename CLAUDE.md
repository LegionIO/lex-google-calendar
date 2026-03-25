# lex-google-calendar: Google Calendar Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to Google Calendar via the Google Calendar REST API v3. Provides runners for calendar and event management.

**GitHub**: https://github.com/LegionIO/lex-google-calendar
**License**: MIT
**Version**: 0.1.0

## Architecture

```
Legion::Extensions::GoogleCalendar
├── Runners/
│   ├── Calendars  # list_calendars, get_calendar, create_calendar, update_calendar, delete_calendar
│   └── Events     # list_events, get_event, create_event, update_event, delete_event
├── Helpers/
│   └── Client     # Faraday connection (Google Calendar API v3, OAuth2 Bearer token)
└── Client         # Standalone client class (includes all runners)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/google_calendar.rb` | Entry point, extension registration |
| `lib/legion/extensions/google_calendar/runners/calendars.rb` | Calendar CRUD runners |
| `lib/legion/extensions/google_calendar/runners/events.rb` | Event CRUD runners |
| `lib/legion/extensions/google_calendar/helpers/client.rb` | Faraday connection builder (OAuth2 Bearer token) |
| `lib/legion/extensions/google_calendar/client.rb` | Standalone Client class |

## Authentication

Google Calendar uses OAuth2 Bearer tokens. Obtain an access token via the Google OAuth2 flow with scope `https://www.googleapis.com/auth/calendar`. Pass the token as `token:` at client construction.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` (~> 2.0) | HTTP client for Google Calendar REST API v3 |

## Development

18 specs total.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
