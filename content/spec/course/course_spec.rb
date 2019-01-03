module Content
  RSpec.describe 'Course aggregate' do
    specify 'create new course' do
      course = Content::Course.new(english_grammar[:course_uuid])
      course.create

      expect(course).to have_applied(course_created)
    end

    specify 'course cannot be created twice' do
      course = Content::Course.new(english_grammar[:course_uuid])
      course.create

      expect { course.create }.to(raise_error(Content::Course::AlreadyCreated))
    end

    specify 'course cannot be created again after removal' do
      course = Content::Course.new(english_grammar[:course_uuid])
      course.create
      course.remove

      expect { course.create }.to(raise_error(Content::Course::AlreadyCreated))
    end

    specify 'set course title' do
      course = Content::Course.new(english_grammar[:course_uuid])
      course.create
      course.set_title(english_grammar[:title])

      expect(course).to have_applied(course_created, course_title_set)
    end

    specify 'remove a course' do
      course = Content::Course.new(english_grammar[:course_uuid])
      course.create
      course.set_title(english_grammar[:title])
      course.remove

      expect(course).to have_applied(course_created, course_title_set, course_removed)
    end

    specify 'course cannot be removed twice' do
      course = Content::Course.new(english_grammar[:course_uuid])
      course.create
      course.remove

      expect { course.remove }.to(raise_error(Content::Course::Removed))
    end

    specify 'cannot make operations on not created course' do
      course = Content::Course.new(english_grammar[:course_uuid])

      expect { course.set_title(english_grammar[:title]) }.to(raise_error(Content::Course::NotCreated))
      expect { course.remove }.to(raise_error(Content::Course::NotCreated))
    end

    specify 'cannot make operations on removed course' do
      course = Content::Course.new(english_grammar[:course_uuid])
      course.create
      course.remove

      expect { course.set_title(english_grammar[:title]) }.to(raise_error(Content::Course::Removed))
    end

    private

    def course_created
      an_event(Content::CourseCreated).with_data(
        course_uuid: english_grammar[:course_uuid]
      ).strict
    end

    def course_title_set
      an_event(Content::CourseTitleSet).with_data(
        course_uuid: english_grammar[:course_uuid],
        title: english_grammar[:title]
      ).strict
    end

    def course_removed
      an_event(Content::CourseRemoved).with_data(
        course_uuid: english_grammar[:course_uuid]
      ).strict
    end

    def english_grammar
      {
        course_uuid: 'e319e624-4449-4c90-9283-02300dcdd293',
        title: 'English Grammar'
      }
    end
  end
end
