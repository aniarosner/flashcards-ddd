class RenameDecksDecksToUiDecksDecks < ActiveRecord::Migration[5.2]
  def change
    rename_table :decks_decks, :ui_decks_decks
  end
end
