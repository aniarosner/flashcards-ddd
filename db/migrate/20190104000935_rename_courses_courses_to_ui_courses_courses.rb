class RenameCoursesCoursesToUiCoursesCourses < ActiveRecord::Migration[5.2]
  def change
    rename_table :courses_courses, :ui_courses_courses
  end
end
