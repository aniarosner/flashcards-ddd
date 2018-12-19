module Content
  class Course
    include AggregateRoot

    AlreadyCreated = Class.new(StandardError)

    def initialize(course_uuid)
      @course_uuid  = course_uuid
      @state = Content::CourseState.new(:initialized)
    end

    def create
      raise AlreadyCreated if @state.created?

      apply(Content::CourseCreated.new(data: { course_uuid: @course_uuid }))
    end

    on Content::CourseCreated do |_event|
      @state = Content::CourseState.new(:created)
    end
  end
end
