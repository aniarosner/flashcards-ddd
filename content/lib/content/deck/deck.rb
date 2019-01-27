module Content
  class Deck
    include AggregateRoot

    CourseNotCreated = Class.new(StandardError)
    AlreadyCreated = Class.new(StandardError)
    Removed = Class.new(StandardError)
    NotCreated = Class.new(StandardError)
    CardAlreadyInDeck = Class.new(StandardError)
    CardNotPresent = Class.new(StandardError)

    def initialize(deck_uuid)
      @deck_uuid = deck_uuid
      @state = Content::DeckState.new(:initialized)
      @course_uuid = nil
      @cards = []
    end

    def create_in_course(course_uuid, course_presence_validator)
      raise CourseNotCreated unless course_presence_validator.verify(course_uuid)
      raise AlreadyCreated unless @state.initialized?

      apply(Content::DeckCreatedInCourse.new(data: { deck_uuid: @deck_uuid, course_uuid: course_uuid }))
    end

    def set_title(title)
      raise NotCreated if @state.initialized?
      raise Removed if @state.removed?

      apply(Content::DeckTitleSet.new(data: { deck_uuid: @deck_uuid, title: title }))
    end

    def remove
      raise NotCreated if @state.initialized?
      raise Removed if @state.removed?

      apply(Content::DeckRemoved.new(data: { deck_uuid: @deck_uuid, course_uuid: @course_uuid }))
    end

    def add_card(card)
      raise NotCreated if @state.initialized?
      raise Removed if @state.removed?
      raise CardAlreadyInDeck if card.in?(@cards)

      apply(Content::CardAddedToDeck.new(data: { deck_uuid: @deck_uuid, front: card.front, back: card.back }))
    end

    def remove_card(card)
      raise NotCreated if @state.initialized?
      raise Removed if @state.removed?
      raise CardNotPresent unless card.in?(@cards)

      apply(Content::CardRemovedFromDeck.new(data: { deck_uuid: @deck_uuid, front: card.front, back: card.back }))
    end

    on Content::DeckCreatedInCourse do |event|
      @state = Content::DeckState.new(:created)
      @course_uuid = event.data[:course_uuid]
    end

    on Content::DeckTitleSet do |_event|
    end

    on Content::DeckRemoved do |_event|
      @state = Content::DeckState.new(:removed)
      @cards = []
    end

    on Content::CardAddedToDeck do |event|
      @cards.push(Content::Card.new(event.data[:front], event.data[:back]))
    end

    on Content::CardRemovedFromDeck do |event|
      @cards.delete(Content::Card.new(event.data[:front], event.data[:back]))
    end
  end
end
