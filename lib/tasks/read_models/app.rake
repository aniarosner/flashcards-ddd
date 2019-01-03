namespace :read_models do
  namespace :app do
    desc 'Build all read models'
    task build_all: :environment do
      Rake::Task['read_models:app:build_cards'].execute
      Rake::Task['read_models:app:build_courses'].execute
      Rake::Task['read_models:app:build_decks'].execute
    end

    desc 'Build Cards read model'
    task build_cards: :environment do
      event_store = Rails.configuration.event_store
      Cards::Card.destroy_all

      RailsEventStore::Projection
        .from_all_streams
        .init(-> {})
        .when(
          Cards::EventHandler::EVENTS,
          ->(_state, event) { Cards::EventHandler.new.call(event) }
        ).run(event_store)
    end

    desc 'Build Courses read model'
    task build_courses: :environment do
      event_store = Rails.configuration.event_store
      Courses::Course.destroy_all

      RailsEventStore::Projection
        .from_all_streams
        .init(-> {})
        .when(
          Courses::EventHandler::EVENTS,
          ->(_state, event) { Courses::EventHandler.new.call(event) }
        ).run(event_store)
    end

    desc 'Build Decks read model'
    task build_decks: :environment do
      event_store = Rails.configuration.event_store
      Decks::Deck.destroy_all

      RailsEventStore::Projection
        .from_all_streams
        .init(-> {})
        .when(
          Decks::EventHandler::EVENTS,
          ->(_state, event) { Decks::EventHandler.new.call(event) }
        ).run(event_store)
    end
  end
end
