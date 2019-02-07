module Content
  module Deck
    CourseNotCreated = Class.new(StandardError)
    AlreadyCreated = Class.new(StandardError)
    Removed = Class.new(StandardError)
    NotCreated = Class.new(StandardError)
    CardAlreadyInDeck = Class.new(StandardError)
    CardNotPresent = Class.new(StandardError)

    class CreateInCourse
      def call(state, course_uuid, course_presence_validator)
        raise CourseNotCreated unless course_presence_validator.verify(course_uuid)
        raise AlreadyCreated unless state.initialized?

        Content::DeckCreatedInCourse.new(data: { deck_uuid: state.deck_uuid, course_uuid: course_uuid })
      end
    end

    class SetTitle
      def call(state, title)
        raise NotCreated if state.initialized?
        raise Removed if state.removed?

        Content::DeckTitleSet.new(data: { deck_uuid: state.deck_uuid, title: title })
      end
    end

    class Remove
      def call(state)
        raise NotCreated if state.initialized?
        raise Removed if state.removed?

        Content::DeckRemoved.new(data: { deck_uuid: state.deck_uuid, course_uuid: state.course_uuid })
      end
    end

    class AddCard
      def call(state, card)
        raise NotCreated if state.initialized?
        raise Removed if state.removed?
        raise CardAlreadyInDeck if card.in?(state.cards)

        Content::CardAddedToDeck.new(data: { deck_uuid: state.deck_uuid, front: card.front, back: card.back })
      end
    end

    class RemoveCard
      def call(state, card)
        raise NotCreated if state.initialized?
        raise Removed if state.removed?
        raise CardNotPresent unless card.in?(state.cards)

        Content::CardRemovedFromDeck.new(data: { deck_uuid: state.deck_uuid, front: card.front, back: card.back })
      end
    end
  end
end
