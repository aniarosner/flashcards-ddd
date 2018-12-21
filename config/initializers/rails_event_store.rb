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
    # APP
    store.subscribe(Courses::EventHandler.new, to:
      [
        Content::CourseCreated, Content::CourseTitleSet, Content::CourseRemoved
      ])
    store.subscribe(Decks::EventHandler.new, to:
      [
        Content::DeckCreatedInCourse, Content::DeckRemoved, Content::CourseRemoved
      ])
    store.subscribe(Cards::EventHandler.new, to:
      [ # TODO: Add Content::CourseRemoved
        Content::CardAddedToDeck, Content::CardRemovedFromDeck, Content::DeckRemoved
      ])
    # CONTENT
    store.subscribe(Content::Courses::EventHandler.new, to:
      [
        Content::CourseCreated, Content::CourseRemoved
      ])
  end

  Rails.configuration.command_bus.tap do |bus|
    bus.register(Content::CreateCourse, ->(cmd) { Content::CourseCommandHandler.new.create_course(cmd) })
    bus.register(Content::SetCourseTitle, ->(cmd) { Content::CourseCommandHandler.new.set_course_title(cmd) })
    bus.register(Content::RemoveCourse, ->(cmd) { Content::CourseCommandHandler.new.remove_course(cmd) })
    bus.register(Content::CreateDeckInCourse, ->(cmd) { Content::DeckCommandHandler.new.create_deck_in_course(cmd) })
    bus.register(Content::RemoveDeck, ->(cmd) { Content::DeckCommandHandler.new.remove_deck(cmd) })
    bus.register(Content::AddCardToDeck, ->(cmd) { Content::DeckCommandHandler.new.add_card_to_deck(cmd) })
    bus.register(Content::RemoveCardFromDeck, ->(cmd) { Content::DeckCommandHandler.new.remove_card_from_deck(cmd) })
  end
end
