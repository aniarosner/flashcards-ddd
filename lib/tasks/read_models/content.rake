namespace :read_models do
  namespace :content do
    desc 'Build all read models'
    task build_all: :environment do
      Rake::Task['read_models:content:build_courses'].execute
    end

    desc 'Rebuild Courses read model'
    task build_courses: :environment do
      event_store = Rails.configuration.event_store
      Content::Courses::Course.destroy_all

      RailsEventStore::Projection
        .from_all_streams
        .init(-> {})
        .when(
          Content::Courses::EventHandler::EVENTS,
          ->(_state, event) { Content::Courses::EventHandler.new.call(event) }
        ).run(event_store)
    end
  end
end
