namespace :read_models do
  namespace :ui do
    desc 'Build all read models'
    task build_all: :environment do
      Rake::Task['read_models:app:build_cards'].execute
      Rake::Task['read_models:app:build_courses'].execute
      Rake::Task['read_models:app:build_decks'].execute
    end

    desc 'Build Cards read model'
    task build_cards: :environment do
      event_store = Rails.configuration.event_store
      UI::Cards::Card.destroy_all

      RailsEventStore::Projection
        .from_all_streams
        .init(-> {})
        .when(
          UI::Cards::EventHandler::EVENTS,
          ->(_state, event) { UI::Cards::EventHandler.new.call(event) }
        ).run(event_store)
    end

    desc 'Build Courses read model'
    task build_courses: :environment do
      event_store = Rails.configuration.event_store
      UI::Courses::Course.destroy_all

      RailsEventStore::Projection
        .from_all_streams
        .init(-> {})
        .when(
          UI::Courses::EventHandler::EVENTS,
          ->(_state, event) { UI::Courses::EventHandler.new.call(event) }
        ).run(event_store)
    end

    desc 'Build Decks read model'
    task build_decks: :environment do
      event_store = Rails.configuration.event_store
      UI::Decks::Deck.destroy_all

      RailsEventStore::Projection
        .from_all_streams
        .init(-> {})
        .when(
          UI::Decks::EventHandler::EVENTS,
          ->(_state, event) { UI::Decks::EventHandler.new.call(event) }
        ).run(event_store)
    end
  end
end
