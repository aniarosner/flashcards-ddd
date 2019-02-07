module Content
  class DeckCommandHandler
    def initialize
      @event_store = Rails.configuration.event_store
      @course_presence_validator = Content::CoursePresenceValidator.new
    end

    def create_deck_in_course(cmd)
      with_state(cmd.deck_uuid) do |state|
        Deck::CreateInCourse.new.call(state, cmd.course_uuid, @course_presence_validator)
      end
    end

    def set_deck_title(cmd)
      with_state(cmd.deck_uuid) do |state|
        Deck::SetTitle.new.call(state, cmd.title)
      end
    end

    def remove_deck(cmd)
      with_state(cmd.deck_uuid) do |state|
        Deck::Remove.new.call(state)
      end
    end

    def add_card_to_deck(cmd)
      card = Content::Card.new(cmd.front, cmd.back)
      with_state(cmd.deck_uuid) do |state|
        Deck::AddCard.new.call(state, card)
      end
    end

    def remove_card_from_deck(cmd)
      card = Content::Card.new(cmd.front, cmd.back)
      with_state(cmd.deck_uuid) do |state|
        Deck::RemoveCard.new.call(state, card)
      end
    end

    private

    attr_reader :event_store

    def with_state(deck_uuid)
      version = -1
      state   = DeckState.new(deck_uuid, :initialized, nil, [])
      event_store.read.stream(stream_name(deck_uuid)).each do |event|
        state.apply(event)
        version += 1
      end

      events = yield state
      event_store.publish(events, stream_name: stream_name(deck_uuid), expected_version: version)
    end

    def stream_name(deck_uuid)
      "Content::Deck$#{deck_uuid}"
    end
  end
end
