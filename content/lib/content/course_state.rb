module Content
  class CourseState
    InvalidState = Class.new(StandardError)
    VALID_STATES = %i[created].freeze

    def initialize(state)
      raise InvalidState unless state.in?(VALID_STATES)

      @state = state
    end

    def created?
      @state == :created
    end
  end
end
