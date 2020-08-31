# frozen_string_literal: true

class Surprise
  class << self
    def record(exception, context = {})
      Honeybadger.notify(exception, context)
    end
  end
end
