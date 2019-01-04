module UI
  module Decks
    class Deck < ActiveRecord::Base
      self.table_name = 'decks_decks'

      scope :from_course, ->(course_uuid) { where(course_uuid: course_uuid) if course_uuid.present? }
    end
  end
end
