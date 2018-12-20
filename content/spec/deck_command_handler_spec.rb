module Deck
  RSpec.describe 'CommandHandler' do
    specify 'create a course' do
      Content::CourseCommandHandler.new.create_course(create_course)
      Content::DeckCommandHandler.new.add_deck_to_course(add_deck_to_course)

      expect(event_store).to have_published(deck_added_to_course)
    end

    private

    def create_course
      Content::CreateCourse.new(
        course_uuid: course_english_grammar[:course_uuid]
      )
    end

    def add_deck_to_course
      Content::AddDeckToCourse.new(
        course_uuid: course_english_grammar[:course_uuid],
        deck_uuid: deck_phrasal_verbs[:deck_uuid]
      )
    end

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

    def event_store
      Rails.configuration.event_store
    end
  end
end
