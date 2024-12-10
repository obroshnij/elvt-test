class ApplicationService
  module Errors
    class Error < StandardError; end
    class NotImplementedError < Error; end
  end

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

  def call
    raise Errors::NotImplementedError, "Method #call is not implemented on service instance level"
  end
end
