# frozen_string_literal: true

class TenablescClient
  # Abstract Error class for TenablescClient.
  class Error < ::StandardError
    # Raise a custom error namespace.
    # @param [String] msg The exception message.
    # @example
    #   TenablescClient::Error.new('This is a custom error.')
    def initialize(msg)
      super
    end
  end
end
