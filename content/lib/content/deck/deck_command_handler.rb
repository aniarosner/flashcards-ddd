module Content
  class DeckCommandHandler
    def initialize
      @event_store = Rails.configuration.event_store
      @course_presence_validator = Content::CoursePresenceValidator.new
    end

    def create_deck_in_course(cmd)
      with_aggregate(cmd.deck_uuid) do |deck|
        deck.create_in_course(cmd.course_uuid, @course_presence_validator)
      end
    end

    def set_deck_title(cmd)
      with_aggregate(cmd.deck_uuid) do |deck|
        deck.set_title(cmd.title)
      end
    end

    def remove_deck(cmd)
      with_aggregate(cmd.deck_uuid) do |deck|
        deck.remove
      end
    end

    def add_card_to_deck(cmd)
      card = Content::Card.new(cmd.front, cmd.back)
      with_aggregate(cmd.deck_uuid) do |deck|
        deck.add_card(card)
      end
    end

    def remove_card_from_deck(cmd)
      card = Content::Card.new(cmd.front, cmd.back)
      with_aggregate(cmd.deck_uuid) do |deck|
        deck.remove_card(card)
      end
    end

    private

    attr_reader :event_store

    def with_aggregate(deck_uuid)
      version = -1
      state   = DeckState.new(deck_uuid, :initialized, nil, [])
      event_store.read.stream(stream_name(deck_uuid)).each do |event|
        state.apply(event)
        version += 1
      end
      yield deck = Deck.new(state)
      event_store.publish(deck.changes, stream_name: stream_name(deck_uuid), expected_version: version)
    end

    def stream_name(deck_uuid)
      "Content::Deck$#{deck_uuid}"
    end
  end
end
