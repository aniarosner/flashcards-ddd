module Content
  class Deck
    CourseNotCreated = Class.new(StandardError)
    AlreadyCreated = Class.new(StandardError)
    Removed = Class.new(StandardError)
    NotCreated = Class.new(StandardError)
    CardAlreadyInDeck = Class.new(StandardError)
    CardNotPresent = Class.new(StandardError)

    attr_reader :deck_uuid, :course_uuid

    def initialize(deck_uuid)
      @deck_uuid = deck_uuid
      @state = :initialized
      @course_uuid = nil
      @cards = []
    end

    def create_in_course(course_uuid)
      self.state = :created
      self.course_uuid = course_uuid
    end

    def set_title; end

    def remove
      self.state = :removed
      self.cards = []
    end

    def add_card(card)
      cards.push(card)
    end

    def remove_card(card)
      cards.delete(card)
    end

    def can_create_in_course?(course_uuid, course_presence_validator)
      raise Deck::CourseNotCreated unless course_presence_validator.verify(course_uuid)
      raise Deck::AlreadyCreated unless initialized?
    end

    def can_set_title?
      raise Deck::NotCreated if initialized?
      raise Deck::Removed if removed?
    end

    def can_remove?
      raise Deck::NotCreated if initialized?
      raise Deck::Removed if removed?
    end

    def can_add_card?(card)
      raise Deck::NotCreated if initialized?
      raise Deck::Removed if removed?
      raise Deck::CardAlreadyInDeck if card.in?(cards)
    end

    def can_remove_card?(card)
      raise Deck::NotCreated if initialized?
      raise Deck::Removed if removed?
      raise Deck::CardNotPresent unless card.in?(cards)
    end

    private

    attr_accessor :state, :cards
    attr_writer :course_uuid

    def initialized?
      state.equal?(:initialized)
    end

    def created?
      state.equal?(:created)
    end

    def removed?
      state.equal?(:removed)
    end
  end
end
