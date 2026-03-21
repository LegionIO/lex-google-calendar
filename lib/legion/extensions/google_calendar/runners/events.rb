# frozen_string_literal: true

module Legion
  module Extensions
    module GoogleCalendar
      module Runners
        module Events
          def list_events(calendar_id:, time_min: nil, time_max: nil, **)
            params = {}
            params[:timeMin]      = time_min if time_min
            params[:timeMax]      = time_max if time_max
            params[:singleEvents] = true
            params[:orderBy]      = 'startTime'
            resp = connection(**).get("/calendars/#{calendar_id}/events", params)
            { events: resp.body }
          end

          def get_event(calendar_id:, event_id:, **)
            resp = connection(**).get("/calendars/#{calendar_id}/events/#{event_id}")
            { event: resp.body }
          end

          def create_event(calendar_id:, summary:, start_time:, end_time:, description: nil, location: nil, **)
            body = {
              summary: summary,
              start:   { dateTime: start_time },
              end:     { dateTime: end_time }
            }
            body[:description] = description if description
            body[:location]    = location if location
            resp = connection(**).post("/calendars/#{calendar_id}/events", body)
            { event: resp.body }
          end

          def update_event(calendar_id:, event_id:, summary: nil, start_time: nil, end_time: nil,
                           description: nil, location: nil, **)
            body = {}
            body[:summary]     = summary if summary
            body[:start]       = { dateTime: start_time } if start_time
            body[:end]         = { dateTime: end_time } if end_time
            body[:description] = description if description
            body[:location]    = location if location
            resp = connection(**).patch("/calendars/#{calendar_id}/events/#{event_id}", body)
            { event: resp.body }
          end

          def delete_event(calendar_id:, event_id:, **)
            resp = connection(**).delete("/calendars/#{calendar_id}/events/#{event_id}")
            { deleted: resp.status == 204, event_id: event_id }
          end
        end
      end
    end
  end
end
