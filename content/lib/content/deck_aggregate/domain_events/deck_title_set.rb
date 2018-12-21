module Content
  class DeckTitleSet < RailsEventStore::Event
    SCHEMA = {
      deck_uuid: String,
      title: Set
    }.freeze

    def self.strict(data:)
      ClassyHash.validate(data, SCHEMA)
      new(data: data)
    end
  end
end
