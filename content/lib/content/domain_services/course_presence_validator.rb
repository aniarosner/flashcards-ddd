module Content
  class CoursePresenceValidator
    def verify(course_uuid)
      Content::Courses::ReadModel.new.find(course_uuid).present?
    end
  end
end
