# Abstraction for Service object
# Child class should inherit from it and define instance method that holds logic. Example:
#
#   class NewService < ApplicationService
#     attr_accessor :user
#
#     def call
#       puts "I am executed"
#     end
#   end
#
# Instantiation
#
# NewService.call(user: user)
#
# Note:
# - #call returns service instance itself
# - all public methods on instance are exposed
# - You can define accessor methods on service instance and pass variables to them from outside as arguments to `.call` method
#

class ApplicationService
  module Errors
    class Error < StandardError; end
    class NotImplementedError < Error; end
  end

  # @return ApplicationService instance
  def self.call(**)
    instance = new(**)
    instance.call
    instance
  end

  def initialize(**kwargs)
    kwargs.each do |k, v|
      self.instance_variable_set("@#{k}", v) if defined?(k)
    end
  end

  # @abstractmethod
  def call
    raise Errors::NotImplementedError, "Method #call is not implemented on service instance level"
  end
end
