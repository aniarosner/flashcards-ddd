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
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid], SuccessCoursePresenceValidator.new)
      deck.create_in_course(english_grammar[:course_uuid])

      expect(deck).to have_applied(deck_created_in_course)
    end

    specify 'cannot add deck twice' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid], SuccessCoursePresenceValidator.new)
      deck.create_in_course(english_grammar[:course_uuid])

      expect { deck.create_in_course(english_grammar[:course_uuid]) }.to(
        raise_error(Content::Deck::AlreadyCreated)
      )
    end

    specify 'cannot add deck to not created course' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid], FailureCoursePresenceValidator.new)

      expect { deck.create_in_course(english_grammar[:course_uuid]) }.to(
        raise_error(Content::Deck::CourseNotCreated)
      )
    end

    specify 'set deck title' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid], SuccessCoursePresenceValidator.new)
      deck.create_in_course(english_grammar[:course_uuid])
      deck.set_title(phrasal_verbs[:title])

      expect(deck).to have_applied(deck_title_set)
    end

    specify 'remove deck' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid], SuccessCoursePresenceValidator.new)
      deck.create_in_course(english_grammar[:course_uuid])
      deck.remove

      expect(deck).to have_applied(deck_created_in_course, deck_removed)
    end

    specify 'cannot remove deck twice' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid], SuccessCoursePresenceValidator.new)
      deck.create_in_course(english_grammar[:course_uuid])
      deck.remove

      expect { deck.remove }.to(raise_error(Content::Deck::Removed))
    end

    specify 'add card to deck' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid], SuccessCoursePresenceValidator.new)
      deck.create_in_course(english_grammar[:course_uuid])
      deck.add_card(Content::Card.new(look_forward_to[:front], look_forward_to[:back]))

      expect(deck).to have_applied(deck_created_in_course, card_added_to_deck)
    end

    specify 'cannot add twice same card to deck' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid], SuccessCoursePresenceValidator.new)
      deck.create_in_course(english_grammar[:course_uuid])
      deck.add_card(Content::Card.new(look_forward_to[:front], look_forward_to[:back]))

      expect { deck.add_card(Content::Card.new(look_forward_to[:front], look_forward_to[:back])) }.to(
        raise_error(Content::Deck::CardAlreadyInDeck)
      )
    end

    specify 'remove card from deck' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid], SuccessCoursePresenceValidator.new)
      deck.create_in_course(english_grammar[:course_uuid])
      deck.add_card(Content::Card.new(look_forward_to[:front], look_forward_to[:back]))
      deck.remove_card(Content::Card.new(look_forward_to[:front], look_forward_to[:back]))

      expect(deck).to have_applied(deck_created_in_course, card_added_to_deck, card_removed_from_deck)
    end

    specify 'cannot remove card from deck that is not present' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid], SuccessCoursePresenceValidator.new)
      deck.create_in_course(english_grammar[:course_uuid])

      expect { deck.remove_card(Content::Card.new(look_forward_to[:front], look_forward_to[:back])) }.to(
        raise_error(Content::Deck::CardNotPresent)
      )
    end

    specify 'cannot make operations on not created deck' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid], SuccessCoursePresenceValidator.new)

      expect { deck.set_title(phrasal_verbs[:title]) }.to(raise_error(Content::Deck::NotCreated))
      expect { deck.add_card(Content::Card.new(look_forward_to[:front], look_forward_to[:back])) }.to(
        raise_error(Content::Deck::NotCreated)
      )
      expect { deck.remove_card(Content::Card.new(look_forward_to[:front], look_forward_to[:back])) }.to(
        raise_error(Content::Deck::NotCreated)
      )
      expect { deck.remove }.to(raise_error(Content::Deck::NotCreated))
    end

    specify 'cannot make operations on removed deck' do
      deck = Content::Deck.new(phrasal_verbs[:deck_uuid], SuccessCoursePresenceValidator.new)
      deck.create_in_course(english_grammar[:course_uuid])
      deck.remove

      expect { deck.set_title(phrasal_verbs[:title]) }.to(raise_error(Content::Deck::Removed))
      expect { deck.add_card(Content::Card.new(look_forward_to[:front], look_forward_to[:back])) }.to(
        raise_error(Content::Deck::Removed)
      )
      expect { deck.remove_card(Content::Card.new(look_forward_to[:front], look_forward_to[:back])) }.to(
        raise_error(Content::Deck::Removed)
      )
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
