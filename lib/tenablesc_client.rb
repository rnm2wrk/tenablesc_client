# frozen_string_literal: true

require_relative 'tenablesc_client/version'
require_relative 'tenablesc_client/exception'
require_relative 'tenablesc_client/resource'
require_relative 'tenablesc_client/request'

Dir[File.join(__dir__, 'modules', '*.rb')].sort.each { |file| require file }

# Nessus resource abstraction.
class TenablescClient
  # @return [TenablescClient::Request] Instance HTTP request object.
  # @see TenablescClient::Request
  attr_reader :request
  # @return [Boolean] whether has a session.
  attr_reader :session
  # @return [Hash] Instance current HTTP headers.
  attr_reader :headers

  include Resource::Asset
  include Resource::Queries
  include Resource::Server
  include Resource::Session

  autoload :Request, 'tenablesc_client/request'

  # @param [Hash] params the options to create a TenablescClient with.
  # @option params [String] :uri ('https://localhost:1443/') Tenable Security Center resource to connect with
  # @option params [String] :access_key (nil) access key to use in the connection
  # @option params [String] :secret_key (nil) secret key to use in the connection
  # @option params [String] :username (nil) Username to use in the connection
  # @option params [String] :password (nil) Password  to use in the connection
  # @option params [String] :ssl_verify_peer (true)  Whether should check valid SSL certificate
  def initialize(params = {})
    default_params = {
      uri: 'https://localhost:1443/',
      ssl_verify_peer: true,
      username: nil,
      password: nil,
      access_key: nil,
      secret_key: nil
    }
    params = default_params.merge(params)
    req_params = params.select { |key, _value| %i[uri ssl_verify_peer].include?(key) }

    @request = TenablescClient::Request.new(req_params)
    @headers = TenablescClient::Request::DEFAULT_HEADERS.dup
    
    set_session_keys(params.fetch(:access_key), params.fetch(:secret_key))
    set_session_userpass(params.fetch(:username), params.fetch(:password)) unless session
    
  end

  # Gets TenablescClient::Session authentication status.
  # @return [Boolean] whether TenablescClient has successfully authenticated.
  def has_session?
    session
  end
end