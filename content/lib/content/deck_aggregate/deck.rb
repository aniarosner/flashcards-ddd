module Content
  class Deck
    include AggregateRoot

    CourseNotCreated = Class.new(StandardError)
    AlreadyCreatedInCourse = Class.new(StandardError)

    def initialize(deck_uuid, course_presence_validator)
      @deck_uuid = deck_uuid
      @state = Content::DeckState.new(:initialized)
      @cards = []
      @course_presence_validator = course_presence_validator
    end

    # TODO: add action create with state :created

    def create_in_course(course_uuid)
      raise AlreadyCreatedInCourse if @state.added_to_course?
      raise CourseNotCreated unless @course_presence_validator.verify(course_uuid)

      apply(Content::DeckCreatedInCourse.new(data: { deck_uuid: @deck_uuid, course_uuid: course_uuid }))
    end

    def add_card(card)
      # TODO: add validation for created state
      apply(Content::CardAddedToDeck.new(data: { deck_uuid: @deck_uuid, front: card.front, back: card.back }))
    end

    def remove_card(card)
      # TODO: add validation for created state
      # TODO: check if card in deck
      apply(Content::CardRemovedFromDeck.new(data: { deck_uuid: @deck_uuid, front: card.front, back: card.back }))
    end

    on Content::DeckCreatedInCourse do |_event|
      @state = Content::DeckState.new(:added_to_course)
    end

    on Content::CardAddedToDeck do |event|
      @cards.push(Content::Card.new(event.data[:front], event.data[:back]))
    end

    on Content::CardRemovedFromDeck do |event|
      @cards.delete(Content::Card.new(event.data[:front], event.data[:back]))
    end
  end
end
