module Content
  class RemoveCardFromDeck
    include Command

    attr_reader :deck_uuid
    attr_reader :front
    attr_reader :back

    def initialize(deck_uuid:, front:, back:)
      @deck_uuid = deck_uuid
      @front = front
      @back = back
    end
  end
end
