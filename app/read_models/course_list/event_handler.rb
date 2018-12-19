module CourseList
  class EventHandler
    def call(domain_event)
      case domain_event
      when Content::CourseCreated
        create_course(domain_event.data[:course_uuid])
      end
    end

    private

    def create_course(course_uuid)
      CourseList::Course.create!(
        course_uuid: course_uuid
      )
    end
  end
end
