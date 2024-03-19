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

  context 'initialize' do
    it 'successful authentication and api token' do
      allow_any_instance_of(TenablescClient::Request).to receive(:get).and_return(
        @mock_api_token
      )
      allow_any_instance_of(Excon::Connection).to receive(:request).and_return(
        Excon::Response.new({ body: Oj.dump(@mock_auth_token) })
      )
      allow_any_instance_of(TenablescClient).to receive(:new).and_return(
        TenablescClient.new(@payload)
      )
      tsc_client = TenablescClient.new(@payload)
      expect(tsc_client).to be_instance_of TenablescClient
      expect(tsc_client.has_session?).to be(true)
      expect(tsc_client.headers).to have_key('X-Cookie')
      expect(tsc_client.headers['X-Cookie']).to eq(
        "token=#{@mock_auth_token['token']}"
      )
      expect(tsc_client.headers).to have_key('X-API-Token')
      expect(tsc_client.headers['X-API-Token']).to eq(@api_token)
    end
  end
end
