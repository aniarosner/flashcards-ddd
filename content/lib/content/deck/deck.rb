module Content
  class DeckCourse
    def initialize
      @course_uuid = nil
    end

    attr_accessor :course_uuid
  end

  class DeckCards
    def initialize
      @cards = []
    end

    def add_card(card)
      raise Deck::CardAlreadyInDeck if card.in?(@cards)

      @cards.push(card)
    end

    def remove_card(card)
      raise Deck::CardNotPresent unless card.in?(@cards)

      @cards.delete(card)
    end
  end

  class Deck
    def create_in_course(course_uuid, course, course_presence_validator)
      raise Deck::CourseNotCreated unless course_presence_validator.verify(course_uuid)

      course.course_uuid = course_uuid
      CreatedDeck.new
    end
  end

  class CreatedDeck
    def set_title
      self
    end

    def add_card(card, cards)
      cards.add_card(card)
      self
    end

    def remove_card(card, cards)
      cards.remove_card(card)
      self
    end

    def remove
      RemovedDeck.new
    end
  end

  class RemovedDeck
  end
end
