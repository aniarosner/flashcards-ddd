module Content
  class DeckProjection
    State = Struct.new(:deck, :version)

    def initialize(event_store)
      @event_store = event_store
    end

    def call(deck, stream_name)
      RubyEventStore::Projection
        .from_stream(stream_name)
        .init(-> { State.new(deck, -1) })
        .when(Content::DeckCreatedInCourse, method(:apply_created_in_course))
        .when(Content::DeckTitleSet, method(:apply_title_set))
        .when(Content::DeckRemoved, method(:apply_removed))
        .when(Content::CardAddedToDeck, method(:apply_card_added_to_deck))
        .when(Content::CardRemovedFromDeck, method(:apply_card_removed_from_deck))
        .run(event_store)
    end

    private

    def apply_created_in_course(state, event)
      state.deck.create_in_course(event.data[:course_uuid])
      state.version += 1
    end

    def apply_title_set(state, _event)
      state.deck.set_title
      state.version += 1
    end

    def apply_removed(state, _event)
      state.deck.remove
      state.version += 1
    end

    def apply_card_added_to_deck(state, event)
      card = Content::Card.new(event.data[:front], event.data[:back])
      state.deck.add_card(card)
      state.version += 1
    end

    def apply_card_removed_from_deck(state, event)
      card = Content::Card.new(event.data[:front], event.data[:back])
      state.deck.remove_card(card)
      state.version += 1
    end

    attr_reader :event_store
  end
end
