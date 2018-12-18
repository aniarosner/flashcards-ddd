module Content
  class Course
    include AggregateRoot

    def initialize(uuid)
      @uuid  = uuid
      @state = nil
    end

    def create
    end
  end
end
