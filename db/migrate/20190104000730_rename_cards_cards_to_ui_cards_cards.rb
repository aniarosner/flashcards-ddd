class RenameCardsCardsToUiCardsCards < ActiveRecord::Migration[5.2]
  def change
    rename_table :cards_cards, :ui_cards_cards
  end
end
