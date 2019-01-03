module Content
  class Course
    include AggregateRoot

    AlreadyCreated = Class.new(StandardError)
    NotCreated = Class.new(StandardError)
    Removed = Class.new(StandardError)

    def initialize(course_uuid)
      @course_uuid = course_uuid
      @state = Content::CourseState.new(:initialized)
    end

    def create
      raise AlreadyCreated unless @state.initialized?

      apply(Content::CourseCreated.new(data: { course_uuid: @course_uuid }))
    end

    def set_title(title)
      raise NotCreated if @state.initialized?
      raise Removed if @state.removed?

      apply(Content::CourseTitleSet.new(data: { course_uuid: @course_uuid, title: title }))
    end

    def remove
      raise NotCreated if @state.initialized?
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
