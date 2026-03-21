# frozen_string_literal: true

require_relative 'helpers/client'
require_relative 'runners/calendars'
require_relative 'runners/events'

module Legion
  module Extensions
    module GoogleCalendar
      class Client
        include Helpers::Client
        include Runners::Calendars
        include Runners::Events

        attr_reader :opts

        def initialize(token:, **extra)
          @opts = { token: token, **extra }
        end

        def settings
          { options: @opts }
        end

        def connection(**override)
          super(**@opts, **override)
        end
      end
    end
  end
end
