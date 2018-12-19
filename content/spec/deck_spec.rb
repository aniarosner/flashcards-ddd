module Content
  RSpec.describe 'Deck aggregate' do
    specify 'add deck to course' do
      deck = Content::Deck.new(deck_phrasal_verbs[:deck_uuid])
      deck.add_to_course(course_english_grammar[:course_uuid])

      expect(deck).to have_applied(deck_added_to_course)
    end

    private

    def deck_added_to_course
      an_event(Content::DeckAddedToCourse).with_data(
        course_uuid: course_english_grammar[:course_uuid],
        deck_uuid: deck_phrasal_verbs[:deck_uuid]
      ).strict
    end

    def course_english_grammar
      {
        course_uuid: 'e319e624-4449-4c90-9283-02300dcdd293',
        title: 'English Grammar'
      }
    end

    def deck_phrasal_verbs
      {
        deck_uuid: '856a739c-e18c-4831-8958-695feccd2d73'
      }
    end
  end
end
