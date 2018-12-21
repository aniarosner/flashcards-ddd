module Content
  class Course
    include AggregateRoot

    AlreadyCreated  = Class.new(StandardError)
    NotCreated      = Class.new(StandardError)
    AlreadyRemoved  = Class.new(StandardError)

    def initialize(course_uuid)
      @course_uuid = course_uuid
      @state = Content::CourseState.new(:initialized)
    end

    def create
      # TODO: add validation for removed state
      raise AlreadyCreated if @state.created?

      apply(Content::CourseCreated.new(data: { course_uuid: @course_uuid }))
    end

    def set_title(title)
      # TODO: add validation for removed state
      raise NotCreated unless @state.created?

      apply(Content::CourseTitleSet.new(data: { course_uuid: @course_uuid, title: title }))
    end

    def remove
      raise NotCreated unless @state.created?
      raise AlreadyRemoved if @state.removed?

      apply(Content::CourseRemoved.new(data: { course_uuid: @course_uuid }))
    end

    on Content::CourseCreated do |_event|
      @state = Content::CourseState.new(:created)
    end

    on Content::CourseTitleSet do |_event|
    end

    on Content::CourseRemoved do |_event|
      @state = Content::CourseState.new(:removed)
    end
  end
end