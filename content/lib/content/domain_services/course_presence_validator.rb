module Content
  class CoursePresenceValidator
    def verify(course_uuid)
      Content::CourseListReadModel.new.find(course_uuid).present?
    end
  end
end
