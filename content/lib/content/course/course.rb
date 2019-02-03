module Content
  class Course
    include TestAggregateRoot

    AlreadyCreated = Class.new(StandardError)
    NotCreated = Class.new(StandardError)
    Removed = Class.new(StandardError)

    def initialize(course_uuid)
      @course_uuid = course_uuid
      @state = Content::CourseState.new(:initialized)
      @event_store = Rails.configuration.event_store

      build_state
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
      raise Removed if @state.removed?

      apply(Content::CourseRemoved.new(data: { course_uuid: @course_uuid }))
    end

    def apply_strategy(event)
      case event
      when Content::CourseCreated
        @state = Content::CourseState.new(:created)
      when Content::CourseRemoved
        @state = Content::CourseState.new(:removed)
      end
    end

    def stream_name
      "Content::Course$#{@course_uuid}"
    end
  end
end
