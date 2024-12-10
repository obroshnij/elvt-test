# Define errors that may happen in User domain
module Users::Errors
  class Error < StandardError; end
  class UserDataIsNotValidError < Error; end
  class GameEventDataIsNotValidError < Error; end
end
