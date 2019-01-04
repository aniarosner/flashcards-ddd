RSpec.describe UI::Courses::ReadModel do
  specify 'creates course with title' do
    courses_event_handler.call(course_created)
    courses_event_handler.call(course_title_set)
    expect(courses_read_model.all.size).to eq(1)
    assert_course_correct
  end

  specify 'removes course' do
    courses_event_handler.call(course_created)
    courses_event_handler.call(course_title_set)
    courses_event_handler.call(course_removed)
    expect(courses_read_model.all).to be_empty
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
    course = courses_read_model.all.first
    expect(course.course_uuid).to eq(english_grammar[:course_uuid])
    expect(course.title).to eq(english_grammar[:title])
  end

  def courses_event_handler
    @courses_event_handler ||= UI::Courses::EventHandler.new
  end

  def courses_read_model
    @courses_read_model ||= UI::Courses::ReadModel.new
  end

  def english_grammar
    {
      course_uuid: 'e319e624-4449-4c90-9283-02300dcdd293',
      title: 'English Grammar'
    }
  end
end
