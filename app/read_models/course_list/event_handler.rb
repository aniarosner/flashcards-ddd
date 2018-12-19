module CourseList
  class EventHandler
    def call(domain_event)
      data = domain_event.data
      case domain_event
      when Content::CourseCreated
        create_course(data[:course_uuid])
      when Content::CourseTitleSet
        set_course_title(data[:course_uuid], data[:title])
      when Content::CourseRemoved
        remove_course(data[:course_uuid])
      end
    end

    private

    def create_course(course_uuid)
      CourseList::Course.create!(
        course_uuid: course_uuid
      )
    end

    def set_course_title(course_uuid, title)
      course = CourseList::Course.find_by(course_uuid: course_uuid)
      course.update!(title: title)
    end

    def remove_course(course_uuid)
      course = CourseList::Course.find_by(course_uuid: course_uuid)
      course.destroy!
    end
  end
end
