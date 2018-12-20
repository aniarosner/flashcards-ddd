class CreateContentCourseListCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :content_course_list_courses, id: false do |t|
      t.uuid :course_uuid, primary_key: true, null: false, default: 'gen_random_uuid()'
    end
  end
end
