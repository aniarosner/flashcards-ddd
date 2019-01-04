module UI
  module Decks
    class ReadModel
      def from_course(course_uuid)
        Decks::Deck.from_course(course_uuid)
      end

      def find(deck_uuid)
        Decks::Deck.find(deck_uuid)
      end
    end
  end
end
