module Api
  class UsersController < AuthenticatedApiController
    def show
      render json: { user: Api::UserSerializer.new(current_user) }, status: :ok
    end
  end
end
