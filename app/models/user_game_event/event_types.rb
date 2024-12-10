class UserGameEvent < ApplicationRecord
  module EventTypes
    COMPLETED = "completed_event".freeze

    ALL = [COMPLETED]
  end
end