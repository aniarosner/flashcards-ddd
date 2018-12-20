class DeckListReadModel
  def from_course(course_uuid)
    DeckList::Deck.from_course(course_uuid)
  end
end
