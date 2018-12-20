module Content
  class SetCourseTitle
    include Command

    attr_reader :course_uuid
    attr_reader :title

    def initialize(course_uuid:, title:)
      @course_uuid  = course_uuid
      @title        = title
    end
  end
end
