module Api
  class GameEventsController < AuthenticatedApiController
    rescue_from Users::Errors::GameEventDataIsNotValidError, with: :handle_game_event_data_invalid_error

    def create
      Users.create_game_event(
        user: current_user,
        game: game,
        event_type: create_params[:type],
        occured_at: create_params[:occured_at]
      )

      render json: {}, status: :ok
    end

    private

    def create_params
      params.require(:game_event).permit(:game_id, :type, :occured_at)
    end

    # memoize if called several times here
    def game
      Game.find_by(id: create_params[:game_id])
    end

    def handle_game_event_data_invalid_error(exception)
      render json: { error: "Game event creation failed, please fix the the following error and try again. Error: #{exception.message}" }, status: :forbidden
    end
  end
end
