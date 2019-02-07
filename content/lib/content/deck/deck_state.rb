module Content
  class DeckState < Struct.new(:deck_uuid, :state, :course_uuid, :cards)
    def initialized?
      state.equal?(:initialized)
    end

    def created?
      state.equal?(:created)
    end

    def removed?
      state.equal?(:removed)
    end

    def apply(event)
      case event
      when Content::DeckCreatedInCourse
        self.state = :created
        self.course_uuid = event.data[:course_uuid]
      when Content::DeckRemoved
        self.state = :removed
        self.cards = []
      when Content::CardAddedToDeck
        cards.push(Content::Card.new(event.data[:front], event.data[:back]))
      when Content::CardRemovedFromDeck
        cards.delete(Content::Card.new(event.data[:front], event.data[:back]))
      end
    end
  end
end
