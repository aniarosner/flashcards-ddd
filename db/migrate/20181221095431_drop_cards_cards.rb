class DropCardsCards < ActiveRecord::Migration[5.2]
  def change
    drop_table :cards_cards do |t|
      t.uuid :deck_uuid, primary_key: true, null: false, default: 'gen_random_uuid()'
      t.string :front, null: false
      t.string :back, null: false
    end
  end
end
