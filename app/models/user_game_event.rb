class UserGameEvent < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :user, presence: true
  validates :game, presence: true
  validates :game_event_type, presence: true

  enum :game_event_type, EventTypes::ALL.index_by(&:to_sym), scopes: false
end
