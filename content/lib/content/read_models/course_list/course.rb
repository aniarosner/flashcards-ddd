module Content
  module CourseList
    class Course < ApplicationRecord
      self.table_name = 'content_course_list_courses'
    end
  end
end
