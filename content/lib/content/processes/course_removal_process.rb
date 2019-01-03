module Content
  class CourseRemovalProcess
    def initialize(event_store: Rails.configuration.event_store, command_bus: Rails.configuration.command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def call(event)
      case event
      when Content::CourseRemoved
        remove_decks_from_course(event.data[:course_uuid])
      when Content::DeckCreatedInCourse, Content::DeckRemoved
        store_event(event)
      end
    end

    private

    def remove_decks_from_course(course_uuid)
      deck_uuids = load_deck_uuids(course_uuid)
      deck_uuids.each do |deck_uuid|
        @command_bus.call(Content::RemoveDeck.new(course_uuid: course_uuid, deck_uuid: deck_uuid))
      end
    end

    def load_deck_uuids(course_uuid)
      events = @event_store.read.stream(stream_name(course_uuid))
      deck_uuids = []

      events.each do |event|
        case event
        when Content::DeckCreatedInCourse
          deck_uuids.push(event.data[:deck_uuid])
        when Content::DeckRemoved
          deck_uuids.delete(event.data[:deck_uuid])
        end
      end

      deck_uuids
    end

    def store_event(event)
      stream_name = stream_name(event.data[:course_uuid])
      past_events_size = @event_store.read.stream(stream_name).to_a.size
      last_stored_event = past_events_size - 1

      @event_store.link(
        event.event_id, stream_name: stream_name, expected_version: last_stored_event
      )
    rescue RubyEventStore::WrongExpectedVersion
      retry
    end

    def stream_name(course_uuid)
      "CourseRemoval$#{course_uuid}"
    end
  end
end
