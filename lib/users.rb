# User domain that is an entry point to different application logic pieces
module Users
  module_function

  # @return User
  # @param[] email    String  email of a user
  # @param[] password String  password of a user
  # Creates a user and returns it to the caller
  def create(**)
    instance = CreateService.call(**)
    instance.user
  end

  # @return void
  # @param user       User
  # @param game       Game
  # @param event_type String  one of the available event types defined in UserGameEvent::EventTypes::ALL
  # @param occured_at DateTime|String(iso8601)  Date when even occured. We use current time in case that is not supplied
  def create_game_event(user:, game:, event_type:, **)
    CreateGameEventService.call(user:, game:, event_type:, **)
  end
end
