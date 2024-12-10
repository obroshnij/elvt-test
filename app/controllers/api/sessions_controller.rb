module Api
  class SessionsController < ApiController
    allow_unauthenticated_access

    def create
      if user = User.authenticate_by(**session_params)
        start_new_session_for(user)

        render json: { token: Current.session.token  }, status: :ok
      else
        render json: { error: "Authentication Failed. Email or Password is incorrect" }, status: :unauthorized
      end
    end

    private

    def session_params
      params.permit(:email, :password)
    end
  end
end
