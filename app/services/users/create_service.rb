module Users
  class CreateService < ApplicationService
    attr_accessor :email, :password

    def call
      user
    end

    def user
      @user ||= create_user!
    end

    private

    def create_user!
      User.create!(
        email:    email,
        password: password
      )
    rescue ActiveModel::ValidationError, ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid => e
      raise Errors::UserDataIsNotValidError, e.message
    ensure
      Rails.logger.error(e) if e.present?
    end
  end
end
