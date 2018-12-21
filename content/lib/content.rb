module Content
end
require_dependency 'content/course_aggregate/commands/set_course_title.rb'
require_dependency 'content/course_aggregate/commands/create_course.rb'
require_dependency 'content/course_aggregate/commands/remove_course.rb'
require_dependency 'content/course_aggregate/domain_events/course_created.rb'
require_dependency 'content/course_aggregate/domain_events/course_removed.rb'
require_dependency 'content/course_aggregate/domain_events/course_title_set.rb'
require_dependency 'content/course_aggregate/course_command_handler.rb'
require_dependency 'content/course_aggregate/course_state.rb'
require_dependency 'content/course_aggregate/course.rb'

require_dependency 'content/deck_aggregate/commands/add_deck_to_course.rb'
require_dependency 'content/deck_aggregate/commands/add_card_to_deck.rb'
require_dependency 'content/deck_aggregate/domain_events/deck_added_to_course.rb'
require_dependency 'content/deck_aggregate/domain_events/card_added_to_deck.rb'
require_dependency 'content/deck_aggregate/card.rb'
require_dependency 'content/deck_aggregate/deck_command_handler.rb'
require_dependency 'content/deck_aggregate/deck_state.rb'
require_dependency 'content/deck_aggregate/deck.rb'

require_dependency 'content/domain_services/course_presence_validator.rb'

require_dependency 'content/read_models/courses/course.rb'
require_dependency 'content/read_models/courses/event_handler.rb'
require_dependency 'content/read_models/courses/read_model.rb'
