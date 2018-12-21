command_bus = Rails.configuration.command_bus

english_grammar = { course_uuid: 'e319e624-4449-4c90-9283-02300dcdd293', title: 'English Grammar' }
phrasal_verbs = { deck_uuid: '856a739c-e18c-4831-8958-695feccd2d73', title: 'Phrasal Verbs' }
look_forward_to = { front: 'Look forward to', back: 'To be pleased about sth that is going to happen' }
look_into = { front: 'Look into', back: 'To investigate, to research' }

command_bus.call(
  Content::CreateCourse.new(course_uuid: english_grammar[:course_uuid])
)
command_bus.call(
  Content::SetCourseTitle.new(course_uuid: english_grammar[:course_uuid], title: english_grammar[:title])
)
command_bus.call(
  Content::CreateDeckInCourse.new(deck_uuid: phrasal_verbs[:deck_uuid], course_uuid: english_grammar[:course_uuid])
)
command_bus.call(
  Content::AddCardToDeck.new(deck_uuid: phrasal_verbs[:deck_uuid], front: look_forward_to[:front], back: look_forward_to[:back])
)
command_bus.call(
  Content::AddCardToDeck.new(deck_uuid: phrasal_verbs[:deck_uuid], front: look_into[:front], back: look_into[:back])
)
