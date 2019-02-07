module Content
  class Deck
    CourseNotCreated  = Class.new(StandardError)
    InvalidState      = Class.new(StandardError)
    CardAlreadyInDeck = Class.new(StandardError)
    CardNotPresent    = Class.new(StandardError)
  end

  class DeckCommandHandler
    def initialize
      @event_store = Rails.configuration.event_store
      @course_presence_validator = Content::CoursePresenceValidator.new
    end

    def create_deck_in_course(cmd)
      load_deck(cmd.deck_uuid) do |deck, course, _cards|
        raise Deck::InvalidState unless deck.respond_to?(:create_in_course)
        deck.create_in_course(cmd.course_uuid, course, @course_presence_validator)
        Content::DeckCreatedInCourse.new(data: { deck_uuid: cmd.deck_uuid, course_uuid: cmd.course_uuid })
      end
    end

    def set_deck_title(cmd)
      load_deck(cmd.deck_uuid) do |deck, _course, _cards|
        raise Deck::InvalidState unless deck.respond_to?(:set_title)
        deck.set_title
        Content::DeckTitleSet.new(data: { deck_uuid: cmd.deck_uuid, title: cmd.title })
      end
    end

    def remove_deck(cmd)
      load_deck(cmd.deck_uuid) do |deck, course, _cards|
        raise Deck::InvalidState unless deck.respond_to?(:remove)
        deck.remove
        Content::DeckRemoved.new(data: { deck_uuid: cmd.deck_uuid, course_uuid: course.course_uuid })
      end
    end

    def add_card_to_deck(cmd)
      card = Content::Card.new(cmd.front, cmd.back)
      load_deck(cmd.deck_uuid) do |deck, _course, cards|
        raise Deck::InvalidState unless deck.respond_to?(:add_card)
        deck.add_card(card, cards)
        Content::CardAddedToDeck.new(data: { deck_uuid: cmd.deck_uuid, front: card.front, back: card.back })
      end
    end

    def remove_card_from_deck(cmd)
      card = Content::Card.new(cmd.front, cmd.back)
      load_deck(cmd.deck_uuid) do |deck, _course, cards|
        raise Deck::InvalidState unless deck.respond_to?(:remove_card)
        deck.remove_card(card, cards)
        Content::CardRemovedFromDeck.new(data: { deck_uuid: cmd.deck_uuid, front: card.front, back: card.back })
      end
    end

    private

    def load_deck(deck_uuid)
      version = -1
      course = DeckCourse.new
      cards = DeckCards.new
      deck = Deck.new

      @event_store.read.stream(stream_name(deck_uuid)).each do |event|
        case event
        when Content::DeckCreatedInCourse
          deck = deck.create_in_course(event.data[:course_uuid], course, @course_presence_validator)
        when Content::DeckTitleSet
          deck = deck.set_title
        when Content::DeckRemoved
          deck = deck.remove
        when Content::CardAddedToDeck
          card = Content::Card.new(event.data[:front], event.data[:back])
          deck = deck.add_card(card, cards)
        when Content::CardRemovedFromDeck
          card = Content::Card.new(event.data[:front], event.data[:back])
          deck = deck.remove_card(card, cards)
        end
        version += 1
      end
      events = yield deck, course, cards
      publish(events, deck_uuid, version)
    end

    def publish(events, deck_uuid, version)
      @event_store.publish(
        events,
        stream_name: stream_name(deck_uuid),
        expected_version: version
      )
    end

    def stream_name(deck_uuid)
      "Content::Deck$#{deck_uuid}"
    end
  end
end
