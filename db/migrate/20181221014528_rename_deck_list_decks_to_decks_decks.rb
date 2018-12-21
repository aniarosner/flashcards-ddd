class RenameDeckListDecksToDecksDecks < ActiveRecord::Migration[5.2]
  def change
    rename_table :deck_list_decks, :decks_decks
  end
end
