module Content
  class CourseRemoved < RailsEventStore::Event
    SCHEMA = {
      course_uuid: String
    }.freeze

    def self.strict(data:)
      ClassyHash.validate(data, SCHEMA)
      new(data: data)
    end
  end
end
