module Api
  class RegistrationsController < ApiController
    allow_unauthenticated_access

    rescue_from Users::Errors::UserDataIsNotValidError, with: :handle_user_creation_failed_error

    def create
      Users.create(**creation_params)

      render json: {}, status: :created
    end

    private

    def creation_params
      params.permit(:email, :password)
    end

    def handle_user_creation_failed_error(exception)
      render json: { error: "User creation failed, please fix the the following error and try again. Error: #{exception.message}" }, status: :forbidden
    end
  end
end
