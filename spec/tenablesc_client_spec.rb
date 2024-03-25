# frozen_string_literal: true

require_relative 'spec_helper'

describe TenablescClient do
  before(:context) do
    @payload = {
      uri: 'http://ness.us',
      username: 'username',
      password: 'password',
      ssl_verify_peer: false
    }
    token = /[a-z0-9]{48}/.random_example
    @mock_auth_token = { 'token' => token }
    @api_token = /([A-Z0-9]{8}-(?:[A-Z0-9]{4}-){3}[A-Z0-9]{12})/.random_example
    @mock_api_token = "return\"#{@api_token}\"\}"
  end

  it 'has a version number' do
    expect(TenablescClient::VERSION).not_to be nil
  end

end
