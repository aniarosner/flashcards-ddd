module Content
  class CourseListReadModel
    def find(course_uuid)
      Content::CourseList::Course.find_by(course_uuid: course_uuid)
    end
  end
end
