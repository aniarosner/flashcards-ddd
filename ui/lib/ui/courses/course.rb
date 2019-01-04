module UI
  module Courses
    class Course < ActiveRecord::Base
      self.table_name = 'ui_courses_courses'
    end
  end
end
