require 'rails_event_store'
require 'aggregate_root'
require 'arkency/command_bus'

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  Rails.configuration.event_store.tap do |store|
    store.subscribe(CourseList::EventHandler.new, to: [Content::CourseCreated, Content::CourseTitleSet])
  end

  Rails.configuration.command_bus.tap do |bus|
    bus.register(Content::CreateCourse, ->(cmd) { Content::CourseCommandHandler.new.create_course(cmd) })
    bus.register(Content::SetCourseTitle, ->(cmd) { Content::CourseCommandHandler.new.set_course_title(cmd) })
  end
end
