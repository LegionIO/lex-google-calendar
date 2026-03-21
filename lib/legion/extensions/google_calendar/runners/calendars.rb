# frozen_string_literal: true

module Legion
  module Extensions
    module GoogleCalendar
      module Runners
        module Calendars
          def list_calendars(**)
            resp = connection(**).get('/users/me/calendarList')
            { calendars: resp.body }
          end

          def get_calendar(calendar_id:, **)
            resp = connection(**).get("/calendars/#{calendar_id}")
            { calendar: resp.body }
          end

          def create_calendar(summary:, description: nil, time_zone: nil, **)
            body = { summary: summary }
            body[:description] = description if description
            body[:timeZone]    = time_zone if time_zone
            resp = connection(**).post('/calendars', body)
            { calendar: resp.body }
          end
        end
      end
    end
  end
end
