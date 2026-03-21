# frozen_string_literal: true

require 'faraday'

module Legion
  module Extensions
    module GoogleCalendar
      module Helpers
        module Client
          def connection(token: nil, **_opts)
            Faraday.new(url: 'https://www.googleapis.com/calendar/v3') do |conn|
              conn.request :json
              conn.response :json, content_type: /\bjson$/
              conn.headers['Authorization'] = "Bearer #{token}" if token
              conn.adapter Faraday.default_adapter
            end
          end
        end
      end
    end
  end
end
