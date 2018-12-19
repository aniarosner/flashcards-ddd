module Content
  class CourseCommandHandler
    def initialize
      @event_store = Rails.configuration.event_store
      @command_bus = Rails.configuration.command_bus
    end

    def create_course(cmd)
      ActiveRecord::Base.transaction do
        with_course(cmd.course_uuid, &:create)
      end
    end

    def set_course_title(cmd)
      ActiveRecord::Base.transaction do
        with_course(cmd.course_uuid) do |course|
          course.set_title(cmd.title)
        end
      end
    end

    def remove_course(cmd)
      ActiveRecord::Base.transaction do
        with_course(cmd.course_uuid) do |course|
          course.remove
        end
      end
    end

    private

    def with_course(course_uuid)
      Content::Course.new(course_uuid).tap do |course|
        load_course(course_uuid, course)
        yield course
        store_course(course)
      end
    end

    def load_course(course_uuid, course)
      course.load(stream_name(course_uuid), event_store: @event_store)
    end

    def store_course(course)
      course.store(event_store: @event_store)
    end

    def stream_name(course_uuid)
      "Content::Course$#{course_uuid}"
    end
  end
end
