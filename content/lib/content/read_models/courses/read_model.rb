module Content
  module Courses
    class ReadModel
      def find(course_uuid)
        Content::Courses::Course.find_by(course_uuid: course_uuid)
      end
    end
  end
end
