module Courses
  class ReadModel
    def all
      Courses::Course.all
    end

    def find(course_uuid)
      Courses::Course.find(course_uuid)
    end
  end
end
