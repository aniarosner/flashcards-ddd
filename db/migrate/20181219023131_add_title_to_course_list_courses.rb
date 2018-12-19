class AddTitleToCourseListCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :course_list_courses, :title, :string
  end
end
