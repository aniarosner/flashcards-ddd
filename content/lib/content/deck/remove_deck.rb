module Content
  class RemoveDeck
    include Command

    attr_reader :deck_uuid

    def initialize(deck_uuid:)
      @deck_uuid = deck_uuid
    end
  end
end
