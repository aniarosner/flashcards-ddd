module Content
  class CourseState
    include Comparable
    InvalidState = Class.new(StandardError)
    VALID_STATES = %i[initialized created removed].freeze

    def initialize(state)
      raise InvalidState unless state.in?(VALID_STATES)

      @state = state
    end

    attr_reader :state

    def <=>(other)
      self.class == other.class && state == other.state ? 0 : -1
    end

    def initialized?
      state == :initialized
    end

    def created?
      state == :created
    end

    def removed?
      state == :removed
    end
  end
end
