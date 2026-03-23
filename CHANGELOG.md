# Changelog

## [0.1.2] - 2026-03-22

### Changed
- Add legion-cache, legion-crypt, legion-data, legion-json, legion-logging, legion-settings, legion-transport as runtime dependencies
- Update spec_helper with real sub-gem helper stubs

## [0.1.0] - 2026-03-21

### Added
- Initial release
- `Helpers::Client` — Faraday connection builder targeting Google Calendar API v3 with Bearer token auth
- `Runners::Calendars` — list_calendars, get_calendar, create_calendar
- `Runners::Events` — list_events, get_event, create_event, update_event, delete_event
- Standalone `Client` class for use outside the Legion framework
