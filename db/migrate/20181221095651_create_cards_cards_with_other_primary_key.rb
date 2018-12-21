class CreateCardsCardsWithOtherPrimaryKey < ActiveRecord::Migration[5.2]
  def change
    create_table :cards_cards, id: false do |t|
      t.uuid :uuid, null: false, primary_key: true, default: 'gen_random_uuid()'
      t.uuid :deck_uuid, null: false
      t.string :front, null: false
      t.string :back, null: false
    end
  end
end
