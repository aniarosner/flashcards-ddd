module Content
  class Course
    include AggregateRoot

    AlreadyCreated  = Class.new(StandardError)
    NotCreated      = Class.new(StandardError)

    def initialize(course_uuid)
      @course_uuid = course_uuid
      @state = Content::CourseState.new(:initialized)
    end

    def create
      raise AlreadyCreated if @state.created?

      apply(Content::CourseCreated.new(data: { course_uuid: @course_uuid }))
    end

    def set_title(title)
      raise NotCreated unless @state.created?

      apply(Content::CourseTitleSet.new(data: { course_uuid: @course_uuid, title: title }))
    end

    on Content::CourseCreated do |_event|
      @state = Content::CourseState.new(:created)
    end

    on Content::CourseTitleSet do |_event|
    end
  end
end
