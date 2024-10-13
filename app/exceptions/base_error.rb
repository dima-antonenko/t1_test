# frozen_string_literal: true

# базовое исключение от которого всё наследуюется
class BaseError < StandardError
  attr_accessor :attr, :message

  def initialize(attr = :attribute, message = "default message")
    @attr = attr
    @message = message
  end

  def call
    { attr => [message] }
  end
end
