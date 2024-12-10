class ApiController < ActionController::API
  include ApiAuthentication

  # order is important
  rescue_from StandardError, with: :handle_internal_server_error
  rescue_from ActionController::ParameterMissing, with: :handle_missing_params_error

  private

  def handle_internal_server_error(err)
    render json: { error: "InternalServerError(#{err.class.name})", message: err.message, backtrace: err.backtrace }, status: :internal_server_error
  end

  def handle_missing_params_error(err)
    render json: { error: "Missing params", message: err.message }, status: :forbidden
  end
end
