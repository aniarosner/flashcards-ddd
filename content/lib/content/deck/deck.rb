module Content
  class Deck
    CourseNotCreated = Class.new(StandardError)
    AlreadyCreated = Class.new(StandardError)
    Removed = Class.new(StandardError)
    NotCreated = Class.new(StandardError)
    CardAlreadyInDeck = Class.new(StandardError)
    CardNotPresent = Class.new(StandardError)

    def initialize(state)
      @state = state
      @changes = []
    end

    attr_reader :changes

    def create_in_course(course_uuid, course_presence_validator)
      raise CourseNotCreated unless course_presence_validator.verify(course_uuid)
      raise AlreadyCreated unless state.initialized?

      apply(Content::DeckCreatedInCourse.new(data: { deck_uuid: state.deck_uuid, course_uuid: course_uuid }))
    end

    def set_title(title)
      raise NotCreated if state.initialized?
      raise Removed if state.removed?

      apply(Content::DeckTitleSet.new(data: { deck_uuid: state.deck_uuid, title: title }))
    end

    def remove
      raise NotCreated if state.initialized?
      raise Removed if state.removed?

      apply(Content::DeckRemoved.new(data: { deck_uuid: state.deck_uuid, course_uuid: state.course_uuid }))
    end

    def add_card(card)
      raise NotCreated if state.initialized?
      raise Removed if state.removed?
      raise CardAlreadyInDeck if card.in?(state.cards)

      apply(Content::CardAddedToDeck.new(data: { deck_uuid: state.deck_uuid, front: card.front, back: card.back }))
    end

    def remove_card(card)
      raise NotCreated if state.initialized?
      raise Removed if state.removed?
      raise CardNotPresent unless card.in?(state.cards)

      apply(Content::CardRemovedFromDeck.new(data: { deck_uuid: state.deck_uuid, front: card.front, back: card.back }))
    end

    private

    attr_reader :state

    def apply(event)
      store_changes(event)
      apply_on_state(event)
    end

    def store_changes(event)
      changes << event
    end

    def apply_on_state(event)
      state.apply(event)
    end
  end
end
