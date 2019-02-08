module Content
  class DeckCommandHandler
    def initialize
      @event_store = Rails.configuration.event_store
      @course_presence_validator = Content::CoursePresenceValidator.new
    end

    def create_deck_in_course(cmd)
      with_aggregate(cmd.deck_uuid) do |deck|
        deck.can_create_in_course?(cmd.course_uuid, @course_presence_validator)
        Content::DeckCreatedInCourse.new(data: { deck_uuid: cmd.deck_uuid, course_uuid: cmd.course_uuid })
      end
    end

    def set_deck_title(cmd)
      with_aggregate(cmd.deck_uuid) do |deck|
        deck.can_set_title?
        Content::DeckTitleSet.new(data: { deck_uuid: cmd.deck_uuid, title: cmd.title })
      end
    end

    def remove_deck(cmd)
      with_aggregate(cmd.deck_uuid) do |deck|
        deck.can_remove?
        Content::DeckRemoved.new(data: { deck_uuid: cmd.deck_uuid, course_uuid: deck.course_uuid })
      end
    end

    def add_card_to_deck(cmd)
      card = Content::Card.new(cmd.front, cmd.back)
      with_aggregate(cmd.deck_uuid) do |deck|
        deck.can_add_card?(card)
        Content::CardAddedToDeck.new(data: { deck_uuid: cmd.deck_uuid, front: card.front, back: card.back })
      end
    end

    def remove_card_from_deck(cmd)
      card = Content::Card.new(cmd.front, cmd.back)
      with_aggregate(cmd.deck_uuid) do |deck|
        deck.can_remove_card?(card)
        Content::CardRemovedFromDeck.new(data: { deck_uuid: cmd.deck_uuid, front: card.front, back: card.back })
      end
    end

    private

    attr_reader :event_store

    def with_aggregate(deck_uuid)
      deck = Content::Deck.new(deck_uuid)
      state = Content::DeckProjection.new(event_store).call(deck, stream_name(deck_uuid))
      event = yield state.deck
      event_store.publish(event, stream_name: stream_name(deck_uuid), expected_version: state.version)
    end

    def stream_name(deck_uuid)
      "Content::Deck$#{deck_uuid}"
    end
  end
end
