module Content
  class AddCourse
    include Command

    attr_reader :course_uuid

    def initialize(course_uuid:)
      @course_uuid = course_uuid
    end
  end
end
