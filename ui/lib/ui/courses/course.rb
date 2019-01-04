module UI
  module Courses
    class Course < ActiveRecord::Base
      self.table_name = 'courses_courses'
    end
  end
end
