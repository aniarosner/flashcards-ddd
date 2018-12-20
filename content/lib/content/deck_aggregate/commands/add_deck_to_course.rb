module Content
  class AddDeckToCourse
    include Command

    attr_reader :course_uuid
    attr_reader :deck_uuid

    def initialize(course_uuid:, deck_uuid:)
      @course_uuid = course_uuid
      @deck_uuid = deck_uuid
    end
  end
end
