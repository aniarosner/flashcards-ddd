namespace :read_models do
  desc 'Build all read models'
  task build_all: :environment do
    Rake::Task['read_models:ui:build_all'].execute
    Rake::Task['read_models:content:build_all'].execute
  end
end
