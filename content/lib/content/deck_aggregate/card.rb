module Content
  class Card
    include Comparable
    InvalidFormat = Class.new(StandardError)

    def initialize(front, back)
      raise InvalidFormat unless front.class == String && back.class == String

      @front = front
      @back = back
    end

    alias eql? ==

    def <=>(other)
      self.class == other.class && front == other.front && back == other.back ? 0 : -1
    end

    def front
      @front.to_s
    end

    def back
      @back.to_s
    end
  end
end
