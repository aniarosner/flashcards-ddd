module UI
  module Cards
    class Card < ActiveRecord::Base
      self.table_name = 'ui_cards_cards'

      scope :from_deck, ->(deck_uuid) { where(deck_uuid: deck_uuid) if deck_uuid.present? }
    end
  end
end
