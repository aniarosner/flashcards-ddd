module Cards
  class EventHandler
    def call(domain_event)
      data = domain_event.data
      case domain_event
      when Content::CardAddedToDeck
        create_card(data[:deck_uuid], data[:front], data[:back])
      when Content::CardRemovedFromDeck
        remove_card(data[:deck_uuid], data[:front], data[:back])
      end
    end

    private

    def create_card(deck_uuid, front, back)
      Cards::Card.create!(
        deck_uuid: deck_uuid,
        front: front,
        back: back
      )
    end

    def remove_card(deck_uuid, front, back)
      card = Cards::Card.find_by(deck_uuid: deck_uuid, front: front, back: back)
      card.destroy!
    end
  end
end
