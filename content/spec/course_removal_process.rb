module Content
  RSpec.describe 'CourseRemovalProcess' do
    specify 'remove course with decks' do
      process = Content::CourseRemovalProcess.new(command_bus: command_bus)
      [course_created, deck_created_in_course, course_removed].each do |event|
        event_store.append(event)
        process.call(event)
      end

      expect(command_bus.commands.first).to be_instance_of(Content::RemoveDeck)
    end

    private

    class FakeCommandBus
      attr_reader :commands

      def initialize
        @commands = []
      end

      def call(command)
        @commands << command
      end
    end

    def course_created
      Content::CourseCreated.strict(data: {
        course_uuid: english_grammar[:course_uuid]
      })
    end

    def course_removed
      Content::CourseRemoved.strict(data: {
        course_uuid: english_grammar[:course_uuid]
      })
    end

    def deck_created_in_course
      Content::DeckCreatedInCourse.strict(data: {
        course_uuid: english_grammar[:course_uuid],
        deck_uuid: phrasal_verbs[:deck_uuid]
      })
    end

    def deck_removed
      Content::DeckRemoved.strict(data: {
        course_uuid: english_grammar[:course_uuid],
        deck_uuid: phrasal_verbs[:deck_uuid]
      })
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

    def event_store
      Rails.configuration.event_store
    end

    def command_bus
      @command_bus ||= FakeCommandBus.new
    end
  end
end
