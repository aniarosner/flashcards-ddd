RSpec.describe UI::Cards::ReadModel do
  specify 'adds card to deck' do
    cards_event_handler.call(card_added_to_deck)
    assert_card_correct
  end

  specify 'removes card from deck' do
    cards_event_handler.call(card_added_to_deck)
    cards_event_handler.call(card_removed_from_deck)
    expect(cards_read_model.from_deck(phrasal_verbs[:deck_uuid])).to be_empty
  end

  specify 'removes deck with all cards' do
    cards_event_handler.call(card_added_to_deck)
    cards_event_handler.call(deck_removed)
    expect(cards_read_model.from_deck(phrasal_verbs[:deck_uuid])).to be_empty
  end

  def deck_removed
    Content::DeckRemoved.strict(data: {
      course_uuid: english_grammar[:course_uuid],
      deck_uuid: phrasal_verbs[:deck_uuid]
    })
  end

  def card_added_to_deck
    Content::CardAddedToDeck.strict(data: {
      deck_uuid: phrasal_verbs[:deck_uuid],
      front: look_forward_to[:front],
      back: look_forward_to[:back]
    })
  end

  def card_removed_from_deck
    Content::CardRemovedFromDeck.strict(data: {
      deck_uuid: phrasal_verbs[:deck_uuid],
      front: look_forward_to[:front],
      back: look_forward_to[:back]
    })
  end

  def assert_card_correct
    card = cards_read_model.from_deck(phrasal_verbs[:deck_uuid]).first
    expect(card.deck_uuid).to eq(phrasal_verbs[:deck_uuid])
    expect(card.front).to eq(look_forward_to[:front])
    expect(card.back).to eq(look_forward_to[:back])
  end

  def cards_event_handler
    @cards_event_handler ||= UI::Cards::EventHandler.new
  end

  def cards_read_model
    @cards_read_model ||= UI::Cards::ReadModel.new
  end

  def look_forward_to
    {
      front: 'Look forward to',
      back: 'To be pleased about sth that is going to happen'
    }
  end

  def english_grammar
    {
      course_uuid: 'e319e624-4449-4c90-9283-02300dcdd293',
      title: 'English Grammar'
    }
  end

  def phrasal_verbs
    {
      deck_uuid: '856a739c-e18c-4831-8958-695feccd2d73',
      title: 'Phrasal Verbs'
    }
  end
end
