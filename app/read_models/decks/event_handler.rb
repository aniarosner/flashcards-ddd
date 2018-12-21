module Decks
  class EventHandler
    def call(domain_event)
      data = domain_event.data
      case domain_event
      when Content::DeckCreatedInCourse
        create_deck_in_course(data[:deck_uuid], data[:course_uuid])
      end
    end

    private

    def create_deck_in_course(deck_uuid, course_uuid)
      Decks::Deck.create!(
        deck_uuid: deck_uuid,
        course_uuid: course_uuid
      )
    end
  end
end
