module Cards
  class Card < ApplicationRecord
    self.table_name = 'cards_cards'

    scope :from_deck, ->(deck_uuid) { where(deck_uuid: deck_uuid) if deck_uuid.present? }
  end
end
