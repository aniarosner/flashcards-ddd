module Content
  class DeckState
    InvalidState = Class.new(StandardError)
    VALID_STATES = %i[initialized added_to_course].freeze

    def initialize(state)
      raise InvalidState unless state.in?(VALID_STATES)

      @state = state
    end

    def added_to_course?
      @state == :added_to_course
    end
  end
end
