class CreateDeckListDecks < ActiveRecord::Migration[5.2]
  def change
    create_table :deck_list_decks, id: false do |t|
      t.uuid :deck_uuid, primary_key: true, null: false, default: 'gen_random_uuid()'
      t.uuid :course_uuid
    end
  end
end
