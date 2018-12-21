module Decks
  class EventHandler
    def call(domain_event)
      data = domain_event.data
      case domain_event
      when Content::DeckCreatedInCourse
        create_deck_in_course(data[:deck_uuid], data[:course_uuid])
      when Content::DeckTitleSet
        set_deck_title(data[:deck_uuid], data[:title])
      when Content::DeckRemoved
        remove_deck(data[:deck_uuid])
      end
    end

    private

    def create_deck_in_course(deck_uuid, course_uuid)
      Decks::Deck.create!(
        deck_uuid: deck_uuid,
        course_uuid: course_uuid
      )
    end

    def set_deck_title(deck_uuid, title)
      deck = Decks::Deck.find_by(deck_uuid: deck_uuid)
      deck.update!(title: title)
    end

    def remove_deck(deck_uuid)
      deck = Decks::Deck.find_by(deck_uuid: deck_uuid)
      deck.destroy!
    end
  end
end
