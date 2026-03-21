# frozen_string_literal: true

require 'legion/extensions/google_calendar/version'
require 'legion/extensions/google_calendar/helpers/client'
require 'legion/extensions/google_calendar/runners/calendars'
require 'legion/extensions/google_calendar/runners/events'
require 'legion/extensions/google_calendar/client'

module Legion
  module Extensions
    module GoogleCalendar
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
