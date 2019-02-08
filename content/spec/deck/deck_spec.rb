module Content
  RSpec.describe 'Deck aggregate' do
    class SuccessCoursePresenceValidator
      def verify(_course_uuid)
        true
      end
    end

    class FailureCoursePresenceValidator
      def verify(_course_uuid)
        false
      end
    end

    specify 'add deck to course' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid])

      expect { deck.can_create_in_course?(english_grammar[:course_uuid], SuccessCoursePresenceValidator.new) }.not_to(
        raise_error
      )
    end

    specify 'cannot add deck twice' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid])
      deck.create_in_course(english_grammar[:course_uuid])

      expect { deck.can_create_in_course?(english_grammar[:course_uuid], SuccessCoursePresenceValidator.new) }.to(
        raise_error(Content::Deck::AlreadyCreated)
      )
    end

    specify 'cannot add deck to not created course' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid])

      expect { deck.can_create_in_course?(english_grammar[:course_uuid], FailureCoursePresenceValidator.new) }.to(
        raise_error(Content::Deck::CourseNotCreated)
      )
    end

    specify 'set deck title' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid])
      deck.create_in_course(english_grammar[:course_uuid])

      expect { deck.can_set_title? }.not_to(raise_error)
    end

    specify 'remove deck' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid])
      deck.create_in_course(english_grammar[:course_uuid])

      expect { deck.can_remove? }.not_to(raise_error)
    end

    specify 'cannot remove deck twice' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid])
      deck.create_in_course(english_grammar[:course_uuid])
      deck.remove

      expect { deck.can_remove? }.to(raise_error(Content::Deck::Removed))
    end

    specify 'add card to deck' do
      card = Content::Card.new(look_forward_to[:front], look_forward_to[:back])
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid])
      deck.create_in_course(english_grammar[:course_uuid])

      expect { deck.can_add_card?(card) }.not_to(raise_error)
    end

    specify 'cannot add twice same card to deck' do
      card = Content::Card.new(look_forward_to[:front], look_forward_to[:back])
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid])
      deck.create_in_course(english_grammar[:course_uuid])
      deck.add_card(card)

      expect { deck.can_add_card?(card) }.to(raise_error(Content::Deck::CardAlreadyInDeck))
    end

    specify 'remove card from deck' do
      card = Content::Card.new(look_forward_to[:front], look_forward_to[:back])
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid])
      deck.create_in_course(english_grammar[:course_uuid])
      deck.add_card(card)

      expect { deck.can_remove_card?(card) }.not_to(raise_error)
    end

    specify 'cannot remove card from deck that is not present' do
      card = Content::Card.new(look_forward_to[:front], look_forward_to[:back])
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid])
      deck.create_in_course(english_grammar[:course_uuid])

      expect { deck.can_remove_card?(card) }.to(raise_error(Content::Deck::CardNotPresent))
    end

    specify 'cannot make operations on not created deck' do
      card = Content::Card.new(look_forward_to[:front], look_forward_to[:back])
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid])

      expect { deck.can_set_title? }.to(raise_error(Content::Deck::NotCreated))
      expect { deck.can_add_card?(card) }.to(raise_error(Content::Deck::NotCreated))
      expect { deck.can_remove_card?(card) }.to(raise_error(Content::Deck::NotCreated))
      expect { deck.can_remove? }.to(raise_error(Content::Deck::NotCreated))
    end

    specify 'cannot make operations on removed deck' do
      card = Content::Card.new(look_forward_to[:front], look_forward_to[:back])
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid])
      deck.create_in_course(english_grammar[:course_uuid])
      deck.remove

      expect { deck.can_set_title? }.to(raise_error(Content::Deck::Removed))
      expect { deck.can_add_card?(card) }.to(raise_error(Content::Deck::Removed))
      expect { deck.can_remove_card?(card) }.to(raise_error(Content::Deck::Removed))
    end

    private

    def deck_created_in_course
      an_event(Content::DeckCreatedInCourse).with_data(
        course_uuid: english_grammar[:course_uuid],
        deck_uuid: phrasal_verbs[:deck_uuid]
      ).strict
    end

    def deck_title_set
      an_event(Content::DeckTitleSet).with_data(
        deck_uuid: phrasal_verbs[:deck_uuid],
        title: phrasal_verbs[:title]
      ).strict
    end

    def deck_removed
      an_event(Content::DeckRemoved).with_data(
        course_uuid: english_grammar[:course_uuid],
        deck_uuid: phrasal_verbs[:deck_uuid]
      ).strict
    end

    def card_added_to_deck
      an_event(Content::CardAddedToDeck).with_data(
        deck_uuid: phrasal_verbs[:deck_uuid],
        front: look_forward_to[:front],
        back: look_forward_to[:back]
      ).strict
    end

    def card_removed_from_deck
      an_event(Content::CardRemovedFromDeck).with_data(
        deck_uuid: phrasal_verbs[:deck_uuid],
        front: look_forward_to[:front],
        back: look_forward_to[:back]
      ).strict
    end

    def look_forward_to
      {
        front: 'Look forward to',
        back: 'To be pleased about sth that is going to happen'
      }
    end

    def english_grammar
      {
        course_uuid: 'e319e624-4449-4c90-9283-02300dcdd293',
        title: 'English Grammar'
      }
    end

    def phrasal_verbs
      {
        deck_uuid: '856a739c-e18c-4831-8958-695feccd2d73',
        title: 'Phrasal Verbs'
      }
    end
  end
end
