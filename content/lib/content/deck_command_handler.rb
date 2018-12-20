module Content
  class DeckCommandHandler
    def initialize
      @event_store = Rails.configuration.event_store
      @command_bus = Rails.configuration.command_bus
      @course_presence_validator = Content::CoursePresenceValidator.new
    end

    def add_deck_to_course(cmd)
      ActiveRecord::Base.transaction do
        with_deck(cmd.deck_uuid) do |deck|
          deck.add_to_course(cmd.course_uuid)
        end
      end
    end

    private

    def with_deck(deck_uuid)
      Content::Deck.new(deck_uuid, @course_presence_validator).tap do |deck|
        load_deck(deck_uuid, deck)
        yield deck
        store_deck(deck)
      end
    end

    def load_deck(deck_uuid, deck)
      deck.load(stream_name(deck_uuid), event_store: @event_store)
    end

    def store_deck(deck)
      deck.store(event_store: @event_store)
    end

    def stream_name(deck_uuid)
      "Content::Deck$#{deck_uuid}"
    end
  end
end
