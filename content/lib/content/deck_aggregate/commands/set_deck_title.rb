module Content
  class SetDeckTitle
    include Command

    attr_reader :deck_uuid
    attr_reader :title

    def initialize(deck_uuid:, title:)
      @deck_uuid = deck_uuid
      @title = title
    end
  end
end
