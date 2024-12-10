class ApiController < ActionController::API
  include ApiAuthentication

  rescue_from StandardError, with: :handle_internal_server_error

  private

  def handle_internal_server_error(err)
    render json: { error: "Internal Server Error", message: err.message, backtrace: err.backtrace }, status: :internal_server_error
  end
end
