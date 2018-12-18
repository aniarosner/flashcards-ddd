module Content
  class Course
    include AggregateRoot

    AlreadyCreated = Class.new(StandardError)

    def initialize(uuid)
      @uuid  = uuid
      @state = nil
    end

    def create
      raise AlreadyCreated if @state.created?

      apply(Content::CourseCreated.new(data: { uuid: @uuid }))
    end

    on Content::CourseCreated do |_event|
      @state = Content::CourseState.new(:created)
    end
  end
end
