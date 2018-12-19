module Content
  class Deck
    include AggregateRoot

    def initialize(deck_uuid)
      @deck_uuid = deck_uuid
      @state = Content::DeckState.new(:initialized)
    end

    def add_to_course(course_uuid)
      apply(Content::DeckAddedToCourse.new(data: { deck_uuid: @deck_uuid, course_uuid: course_uuid }))
    end

    on Content::DeckAddedToCourse do |_event|
      @state = Content::DeckState.new(:added_to_course)
    end
  end
end
