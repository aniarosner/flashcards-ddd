class CreateCardsCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards_cards, id: false do |t|
      t.uuid :deck_uuid, primary_key: true, null: false, default: 'gen_random_uuid()'
      t.string :front, null: false
      t.string :back, null: false
    end
  end
end
