module Content
  RSpec.describe 'CommandHandler' do
    specify 'create a course' do
      Content::CourseCommandHandler.new.create_course(create_course)

      expect(event_store).to have_published(course_created)
    end

    private

    def create_course
      Content::CreateCourse.new(
        course_uuid: course_english_grammar[:course_uuid]
      )
    end

    def course_created
      an_event(Content::CourseCreated).with_data(course_created_data).strict
    end

    def course_created_data
      {
        course_uuid: course_english_grammar[:course_uuid]
      }
    end

    def course_english_grammar
      {
        course_uuid: 'e319e624-4449-4c90-9283-02300dcdd293'
      }
    end

    def event_store
      Rails.configuration.event_store
    end
  end
end
