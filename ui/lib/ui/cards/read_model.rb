module UI
  module Cards
    class ReadModel
      def from_deck(deck_uuid)
        Cards::Card.from_deck(deck_uuid)
      end
    end
  end
end
