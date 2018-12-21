class RenameCourseListCoursesToCoursesCourses < ActiveRecord::Migration[5.2]
  def change
    rename_table :course_list_courses, :courses_courses
  end
end
