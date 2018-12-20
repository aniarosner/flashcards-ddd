class DeckListReadModel
  def from_course(course_uuid)
    DeckList::Deck.from_course(course_uuid).map do |deck|
      { deck_uuid: deck.deck_uuid }
    end
  end
end
