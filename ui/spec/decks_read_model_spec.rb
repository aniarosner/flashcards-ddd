RSpec.describe UI::Decks::ReadModel do
  specify 'creates deck in course' do
    decks_event_handler.call(deck_created_in_course)
    decks_event_handler.call(deck_title_set)
    assert_deck_correct
  end

  specify 'removes deck' do
    decks_event_handler.call(deck_created_in_course)
    decks_event_handler.call(deck_title_set)
    decks_event_handler.call(deck_removed)
    expect(decks_read_model.from_course(english_grammar[:course_uuid])).to be_empty
  end

  def deck_created_in_course
    Content::DeckCreatedInCourse.strict(data: {
      course_uuid: english_grammar[:course_uuid],
      deck_uuid: phrasal_verbs[:deck_uuid]
    })
  end

  def deck_title_set
    Content::DeckTitleSet.strict(data: {
      deck_uuid: phrasal_verbs[:deck_uuid],
      title: phrasal_verbs[:title]
    })
  end

  def deck_removed
    Content::DeckRemoved.strict(data: {
      course_uuid: english_grammar[:course_uuid],
      deck_uuid: phrasal_verbs[:deck_uuid]
    })
  end

  def assert_deck_correct
    deck = decks_read_model.from_course(english_grammar[:course_uuid]).first
    expect(deck.course_uuid).to eq(english_grammar[:course_uuid])
    expect(deck.deck_uuid).to eq(phrasal_verbs[:deck_uuid])
    expect(deck.title).to eq(phrasal_verbs[:title])
  end

  def decks_event_handler
    @decks_event_handler ||= UI::Decks::EventHandler.new
  end

  def decks_read_model
    @decks_read_model ||= UI::Decks::ReadModel.new
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
