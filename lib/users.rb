module Users
  module_function

  def create(**)
    instance = CreateService.call(**)
    instance.user
  end

  def create_game_event(user:, game:, event_type:, **)
    CreateGameEventService.call(**)
  end
end
