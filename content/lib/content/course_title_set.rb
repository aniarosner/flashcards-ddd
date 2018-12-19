module Content
  class CourseTitleSet < RailsEventStore::Event
    SCHEMA = {
      course_uuid: String,
      title: String
    }.freeze

    def self.strict(data:)
      ClassyHash.validate(data, SCHEMA)
      new(data: data)
    end
  end
end
