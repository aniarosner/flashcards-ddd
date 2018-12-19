module Content
end

require_dependency 'content/commands/add_deck_to_course.rb'
require_dependency 'content/commands/create_course.rb'
require_dependency 'content/commands/remove_course.rb'
require_dependency 'content/commands/set_course_title.rb'

require_dependency 'content/domain_events/course_created.rb'
require_dependency 'content/domain_events/course_removed.rb'
require_dependency 'content/domain_events/course_title_set.rb'
require_dependency 'content/domain_events/deck_added_to_course.rb'
