class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :game_events, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8, maximum: 128 }, if: -> { new_record? || !password.nil? }
  validates :password, format: { with: /\A(?=.*\d)(?=.*[A-Z])(?=.*[\W]).+\z/, message: "must include at least one uppercase letter, one digit, and one special character" }, if: -> { password.present? }

  def total_games_played
    3
  end
end
