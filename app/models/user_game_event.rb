class UserGameEvent < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :user, presence: true
  validates :game, presence: true
  validates :game_event_type, presence: true, inclusion: { in: EventTypes::ALL }
  validate :validate_occured_at

  enum :game_event_type, EventTypes::ALL.index_by(&:to_sym), scopes: false

  scope :completed, -> { where(game_event_type: EventTypes::COMPLETED) }

  private

  def validate_occured_at
    if occured_at.nil?
      errors.add(:occured_at, "can not be null")
    end

    if occured_at > Time.current
      errors.add(:occured_at, "can not be in future")
    end
  end
end
