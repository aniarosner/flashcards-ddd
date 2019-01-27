module Content
  RSpec.describe 'DeckCommandHandler' do
    specify 'create deck in course' do
      Content::CourseCommandHandler.new.create_course(create_course)
      Content::DeckCommandHandler.new.create_deck_in_course(create_deck_in_course)
      Content::DeckCommandHandler.new.set_deck_title(set_deck_title)

      expect(event_store).to have_published(deck_created_in_course, deck_title_set)
    end

    specify 'add card to deck' do
      Content::CourseCommandHandler.new.create_course(create_course)
      Content::DeckCommandHandler.new.create_deck_in_course(create_deck_in_course)
      Content::DeckCommandHandler.new.set_deck_title(set_deck_title)
      Content::DeckCommandHandler.new.add_card_to_deck(add_card_to_deck)

      expect(event_store).to have_published(deck_created_in_course, deck_title_set, card_added_to_deck)
    end

    specify 'remove card from deck' do
      Content::CourseCommandHandler.new.create_course(create_course)
      Content::DeckCommandHandler.new.create_deck_in_course(create_deck_in_course)
      Content::DeckCommandHandler.new.set_deck_title(set_deck_title)
      Content::DeckCommandHandler.new.add_card_to_deck(add_card_to_deck)
      Content::DeckCommandHandler.new.remove_card_from_deck(remove_card_from_deck)

      expect(event_store).to have_published(
        deck_created_in_course, deck_title_set, card_added_to_deck, card_removed_from_deck
      )
    end

    private

    def create_course
      Content::CreateCourse.new(
        course_uuid: english_grammar[:course_uuid]
      )
    end

    def create_deck_in_course
      Content::CreateDeckInCourse.new(
        course_uuid: english_grammar[:course_uuid],
        deck_uuid: phrasal_verbs[:deck_uuid]
      )
    end

    def set_deck_title
      Content::SetDeckTitle.new(
        deck_uuid: phrasal_verbs[:deck_uuid],
        title: phrasal_verbs[:title]
      )
    end

    def add_card_to_deck
      Content::AddCardToDeck.new(
        deck_uuid: phrasal_verbs[:deck_uuid],
        front: look_forward_to[:front],
        back: look_forward_to[:back]
      )
    end

    def remove_card_from_deck
      Content::RemoveCardFromDeck.new(
        deck_uuid: phrasal_verbs[:deck_uuid],
        front: look_forward_to[:front],
        back: look_forward_to[:back]
      )
    end

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

    def look_forward_to
      {
        front: 'Look forward to',
        back: 'To be pleased about sth that is going to happen'
      }
    end

    def event_store
      Rails.configuration.event_store
    end
  end
end
