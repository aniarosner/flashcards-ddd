module Content
  class RemoveCourse
    include Command

    attr_reader :course_uuid # TODO: add validation for uuid format

    def initialize(course_uuid:)
      @course_uuid = course_uuid
    end
  end
end
