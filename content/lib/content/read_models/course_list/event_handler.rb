module Content
  module Courses
    class EventHandler
      def call(domain_event)
        data = domain_event.data
        case domain_event
        when Content::CourseCreated
          create_course(data[:course_uuid])
        when Content::CourseRemoved
          remove_course(data[:course_uuid])
        end
      end

      private

      def create_course(course_uuid)
        Content::Courses::Course.create!(
          course_uuid: course_uuid
        )
      end

      def remove_course(course_uuid)
        course = Content::Courses::Course.find_by(course_uuid: course_uuid)
        course.destroy!
      end
    end
  end
end
