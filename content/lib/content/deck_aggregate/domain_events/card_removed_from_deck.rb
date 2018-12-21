module Content
  class CardRemovedFromDeck < RailsEventStore::Event
    SCHEMA = {
      deck_uuid: String,
      front: String,
      back: String
    }.freeze

    def self.strict(data:)
      ClassyHash.validate(data, SCHEMA)
      new(data: data)
    end
  end
end
