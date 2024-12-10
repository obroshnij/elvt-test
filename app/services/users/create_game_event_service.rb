module Users
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
      user.game_events.create!(
        game: game,
        type: game_event_type,
        occured_at: parsed_occured_at
      )
    rescue ActiveModel::ValidationError, ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid => e
      # raise Errors::UserDataIsNotValidError, e.message
    ensure
      Rails.logger.error(e) if e.present?
    end

    def game_event_type
      return event_type if UserGameEvent::EventTypes.include?(event_type)
      
      GAME_EVENT_TYPE_PARAM_MAP[event_type]
    end

    def parsed_occured_at
      return Time.current if occured_at.nil?

      begin
        DateTime.parse(occured_at)
      rescue Date::Error
        raise Errors::GameEventOccurredDateIsNotCorrectError, "Date can not be parsed"
      end
    end
  end
end
