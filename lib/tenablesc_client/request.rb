# frozen_string_literal: true

require 'excon'
require 'oj'
require 'json'

class TenablescClient
  # Abstract http request class for TenablescClient.
  # Provides some helper methods for perform HTTP requests.
  class Request
    # @return [String] The base url of the API.
    attr_reader :url

    # Default HTTP header to be used on the requests.
    DEFAULT_HEADERS = {
      'User-Agent' => 'TenablescClient::Request - rubygems.org tenablesc_client',
      'Content-Type' => 'application/json'
    }.freeze

    # @param [Hash] params the options to create a TenablescClient::Request with.
    # @option params [String] :uri ('https://localhost:1443/') Nessus server to connect with
    # @option params [String] :ssl_verify_peer (true)  Whether should check valid SSL certificate
    def initialize(params = {})
      params = { uri: nil }.merge(params)
      @ssl_verify_peer = params[:ssl_verify_peer] ? true : false
      @url = TenablescClient::Request.uri_parse(params.fetch(:uri))
    end

    # Perform a HTTP GET request.
    # @param [Hash] opts to use in the request.
    # @option opts [String] path The URI path to perform the request.
    # @option opts [String] payload The HTTP body to send.
    # @option opts [String] query The URI query to send.
    # @return [Hash, String] The body of the resposnse if there is any.
    def get(opts = {})
      http_request(opts, :get)
    end

    # Perform a HTTP POST request.
    # @param [Hash] opts to use in the request.
    # @option opts [String] path The URI path to perform the request.
    # @option opts [String] payload The HTTP body to send.
    # @option opts [String] query The URI query to send.
    # @return [Hash, String] The body of the resposnse if there is any.
    def post(opts = {})
      http_request(opts, :post)
    end

    # Perform a HTTP PUT request.
    # @param [Hash] opts to use in the request.
    # @option opts [String] path The URI path to perform the request.
    # @option opts [String] payload The HTTP body to send.
    # @option opts [String] query The URI query to send.
    # @return [Hash, String] The body of the resposnse if there is any.
    def put(opts = {})
      http_request(opts, :put)
    end

    # Perform a HTTP DELETE request.
    # @param [Hash] opts to use in the request.
    # @option opts [String] path The URI path to perform the request.
    # @option opts [String] payload The HTTP body to send.
    # @option opts [String] query The URI query to send.
    # @return [Hash, String] The body of the resposnse if there is any.
    def delete(opts = {})
      http_request(opts, :delete)
    end

    # Parse a receiveid string against the URI stantard.
    # @param [String] uri A string to be validate URI.
    # @return [String] A string uri.
    def self.uri_parse(uri)
      url = URI.parse(uri)
      raise URI::InvalidURIError unless url.scheme

      url.to_s
    end

    private

    # @private HTTP request abstraction to be used.
    # @param [Symbol] method  The HTTP method to be used on the request.
    # @param [Hash] args  Parameters to use in the request.
    # @option args [String] path (nil) The URI path to perform the request.
    # @option args [String] payload (nil) The HTTP body to send.
    # @option args [String] query (nil) The URI query to send.
    # @option args [String] headers (nil) The headers to send.
    # @return [Hash, String] The body of the resposnse if there is any.
    def http_request(args, method = :get)
      opts = { path: nil, payload: nil, query: nil, headers: nil }.merge(args)
      connection = Excon.new(@url, { ssl_verify_peer: @ssl_verify_peer })
      body = opts[:payload] ? Oj.dump(opts[:payload], mode: :compat) : ''
      options = {
        method: method,
        path: opts.fetch(:path),
        body: body,
        query: opts.fetch(:query),
        headers: opts.fetch(:headers)
      }

      resp = connection.request(options)
      if opts[:format] == 'JSON'
        ret = Oj.load(resp.body)
      else
        ret = resp.data
      end
    rescue Oj::ParseError
      resp.body
    end
  end
end
