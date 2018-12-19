RSpec.describe CourseListReadModel do
  specify 'creates course with title' do
    course_list_event_handler.call(course_created)
    course_list_event_handler.call(course_title_set)
    expect(course_list_read_model.all.size).to eq(1)
    assert_course_correct
  end

  specify 'removes course' do
    course_list_event_handler.call(course_created)
    course_list_event_handler.call(course_title_set)
    course_list_event_handler.call(course_removed)
    expect(course_list_read_model.all.size).to eq(0)
  end

  private

  def course_created
    Content::CourseCreated.new(data: {
      course_uuid: english_grammar[:course_uuid]
    })
  end

  def course_title_set
    Content::CourseTitleSet.new(data: {
      course_uuid: english_grammar[:course_uuid],
      title: english_grammar[:title]
    })
  end

  def course_removed
    Content::CourseRemoved.new(data: {
      course_uuid: english_grammar[:course_uuid]
    })
  end

  def assert_course_correct
    course = course_list_read_model.all.first
    expect(course.course_uuid).to eq(english_grammar[:course_uuid])
    expect(course.title).to eq(english_grammar[:title])
  end

  def course_list_event_handler
    @course_list_event_handler ||= CourseList::EventHandler.new
  end

  def course_list_read_model
    @course_list_read_model ||= CourseListReadModel.new
  end

  def english_grammar
    {
      course_uuid: 'e319e624-4449-4c90-9283-02300dcdd293',
      title: 'English Grammar'
    }
  end
end
