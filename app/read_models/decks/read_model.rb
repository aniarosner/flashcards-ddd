module Decks
  class ReadModel
    def from_course(course_uuid)
      Decks::Deck.from_course(course_uuid)
    end
  end
end
