class AddTitleToDecksDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :decks_decks, :title, :string
  end
end
