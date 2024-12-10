FactoryBot.define do
  factory :user_game_event do
    user
    game
    occured_at { Time.current }
    game_event_type { UserGameEvent::EventTypes::ALL.sample }
  end
end
