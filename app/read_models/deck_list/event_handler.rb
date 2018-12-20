module DeckList
  class EventHandler
    def call(domain_event)
      data = domain_event.data
      case domain_event
      when Content::DeckAddedToCourse
        create_deck(data[:deck_uuid])
        add_deck_to_course(data[:deck_uuid], data[:course_uuid])
      end
    end

    private

    def create_deck(deck_uuid)
      DeckList::Deck.create!(
        deck_uuid: deck_uuid
      )
    end

    def add_deck_to_course(deck_uuid, course_uuid)
      deck = DeckList::Deck.find_by(deck_uuid: deck_uuid)
      deck.update!(course_uuid: course_uuid)
    end
  end
end
