class Game < ApplicationRecord
  has_many :game_events, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3, maximum: 256 }
end
