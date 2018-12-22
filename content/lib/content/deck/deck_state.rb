module Content
  class DeckState
    InvalidState = Class.new(StandardError)
    VALID_STATES = %i[initialized created removed].freeze

    def initialize(state)
      raise InvalidState unless state.in?(VALID_STATES)

      @state = state
    end

    def initialized?
      @state == :initialized
    end

    def created?
      @state == :created
    end

    def removed?
      @state == :removed
    end
  end
end
