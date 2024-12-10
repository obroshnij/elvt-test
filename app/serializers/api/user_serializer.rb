module Api
  class UserSerializer < ApplicationSerializer
    attributes :id, :email, :stats

    def stats
      {
        total_games_played: object.total_games_played
      }
    end
  end
end
