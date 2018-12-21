class RenameContentCourseListCoursesToContentCoursesCourses < ActiveRecord::Migration[5.2]
  def change
    rename_table :content_course_list_courses, :content_courses_courses
  end
end
