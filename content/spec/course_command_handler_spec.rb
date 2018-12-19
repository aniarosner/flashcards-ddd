module Content
  RSpec.describe 'CommandHandler' do
    specify 'create a course' do
      Content::CourseCommandHandler.new.create_course(create_course)

      expect(event_store).to have_published(course_created)
    end

    specify 'set course title' do
      Content::CourseCommandHandler.new.create_course(create_course)
      Content::CourseCommandHandler.new.set_course_title(set_course_title)

      expect(event_store).to have_published(course_created, course_title_set)
    end

    private

    def create_course
      Content::CreateCourse.new(
        course_uuid: course_english_grammar[:course_uuid]
      )
    end

    def set_course_title
      Content::SetCourseTitle.new(
        course_uuid: course_english_grammar[:course_uuid],
        title: course_english_grammar[:title]
      )
    end

    def course_created
      an_event(Content::CourseCreated).with_data(
        course_uuid: course_english_grammar[:course_uuid]
      ).strict
    end

    def course_title_set
      an_event(Content::CourseTitleSet).with_data(
        course_uuid: course_english_grammar[:course_uuid],
        title: course_english_grammar[:title]
      ).strict
    end

    def course_english_grammar
      {
        course_uuid: 'e319e624-4449-4c90-9283-02300dcdd293',
        title: 'English Grammar'
      }
    end

    def event_store
      Rails.configuration.event_store
    end
  end
end
