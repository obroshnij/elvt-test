module Users
  # Service for creating game events
  #   @param           user         User
  #   @param           game         Game
  #   @param           event_type   String
  #   @param(optional) occured_at   DateTime
  #
  # @method game_event  Returns created game_event
  #
  class CreateGameEventService < ApplicationService
    GAME_EVENT_TYPE_PARAM_MAP = {
      "COMPLETED" => UserGameEvent::EventTypes::COMPLETED
    }.freeze

    attr_accessor :user, :game, :event_type, :occured_at

    def call
      game_event
    end

    def game_event
      @game_event ||= create_game_event!
    end

    private

    def create_game_event!
      user.user_game_events.create!(
        game: game,
        game_event_type: game_event_type,
        occured_at: parsed_occured_at
      )
    rescue ActiveModel::ValidationError, ActiveRecord::RecordInvalid => e
      raise Errors::GameEventDataIsNotValidError, e.message
    ensure
      Rails.logger.error(e) if e.present?
    end

    def game_event_type
      return event_type if UserGameEvent::EventTypes::ALL.include?(event_type)

      GAME_EVENT_TYPE_PARAM_MAP[event_type]
    end

    def parsed_occured_at
      return Time.current if occured_at.nil?

      begin
        DateTime.parse(occured_at)
      rescue Date::Error
        raise Errors::GameEventDataIsNotValidError, "Date can not be parsed"
      end
    end
  end
end
