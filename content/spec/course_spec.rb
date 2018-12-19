module Content
  RSpec.describe 'Course aggregate' do
    specify 'create new course' do
      course = Content::Course.new(course_english_grammar[:course_uuid])
      course.create

      expect(course).to have_applied(course_created)
    end

    private

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
  end
end
