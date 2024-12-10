module Api
  class GameEventsController < AuthenticatedApiController
    def create
      Users.create_game_event(
        user: current_user,
        game: game,
        event_type: create_params[:type],
        occured_at: create_params[:occured_at]
      )

      render status: :ok
    end

    private

    def create_params
      params.require(:game_event).permit(:game_id, :type, :occured_at)
    end

    # memoize if called several times here
    def game
      Game.find(create_params[:game_id])
    end
  end
end