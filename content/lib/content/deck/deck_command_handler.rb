module Content
  class DeckCommandHandler
    def initialize
      event_store = Rails.configuration.event_store
      @repository = Aggregate::Repository.new(event_store)
      @course_presence_validator = Content::CoursePresenceValidator.new
    end

    def create_deck_in_course(cmd)
      with_deck(cmd.deck_uuid) do |deck, store|
        deck.create_in_course(cmd.deck_uuid, cmd.course_uuid, @course_presence_validator) { |event| store.call(event) }
      end
    end

    def set_deck_title(cmd)
      with_deck(cmd.deck_uuid) do |deck, store|
        deck.set_title(cmd.title) { |event| store.call(event) }
      end
    end

    def remove_deck(cmd)
      with_deck(cmd.deck_uuid) do |deck, store|
        deck.remove { |event| store.call(event) }
      end
    end

    def add_card_to_deck(cmd)
      card = Content::Card.new(cmd.front, cmd.back)
      with_deck(cmd.deck_uuid) do |deck, store|
        deck.add_card(card) { |event| store.call(event) }
      end
    end

    def remove_card_from_deck(cmd)
      card = Content::Card.new(cmd.front, cmd.back)
      with_deck(cmd.deck_uuid) do |deck, store|
        deck.remove_card(card) { |event| store.call(event) }
      end
    end

    private

    attr_reader :repository

    def with_deck(deck_uuid)
      stream_name = "Content::Deck$#{deck_uuid}"
      repository.with_aggregate(Content::Deck.new, stream_name) do |deck, store|
        yield deck, store
      end
    end
  end
end
