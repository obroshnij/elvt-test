module Users::Errors
  class Error < StandardError; end
  class UserDataIsNotValidError < Error; end
end
