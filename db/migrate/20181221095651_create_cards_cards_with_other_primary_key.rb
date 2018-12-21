class CreateCardsCardsWithOtherPrimaryKey < ActiveRecord::Migration[5.2]
  def change
    create_table :cards_cards, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid :deck_uuid, null: false
      t.string :front, null: false
      t.string :back, null: false
    end
  end
end
