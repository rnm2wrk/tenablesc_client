# frozen_string_literal: true

require_relative '../spec_helper'

describe TenablescClient::Request do
  before(:context) do
    @tenable_request = TenablescClient::Request.new(
      { uri: 'http://ness.us', ssl_verify_peer: true }
    )
  end

  context 'initialize' do
    it 'when valid uri' do
      expect(
        TenablescClient::Request.new({ uri: 'http://ness.us' })
      ).to be_instance_of(TenablescClient::Request)
    end

    it 'no uri was given' do
      expect { TenablescClient::Request.new }.to raise_error(URI::InvalidURIError)
    end

    it 'when nil on into initialize, should raise TypeError exception' do
      expect {
        TenablescClient::Request.new(nil)
      }.to raise_error(TypeError)
      expect {
        TenablescClient::Request.new({})
      }.to raise_error(URI::InvalidURIError)
    end

    it 'when uri is nil, should raise URI::InvalidURIError exception' do
      expect {
        TenablescClient::Request.new({ uri: nil })
      }.to raise_error(URI::InvalidURIError)
    end
  end

  context '.url' do
    it 'can NOT read from class method' do
      expect { TenablescClient::Request.url }.to raise_error(NoMethodError)
    end
    it 'can NOT write from class method' do
      expect {
        TenablescClient::Request.url = 'none'
      }.to raise_error(NoMethodError)
    end
    it 'can read from instance method' do
      # read
      expect(@tenable_request.url).to eq('http://ness.us')
    end
    it 'can write from instance method' do
      # write
      expect {
        @tenable_request.url = 'http://nessus.io'
      }.to raise_error(NoMethodError)
    end
  end

  context '.headers' do
    it 'can NOT read/write using class method' do
      expect { TenablescClient::Request.headers }.to raise_error(NoMethodError)
    end

    it 'can NOT read/write using instance method' do
      req = TenablescClient::Request.new({ uri: 'http://ness.us' })
      # read
      expect { req.headers }.to raise_error(NoMethodError)
    end

    it 'still default' do
      # hard coded default header
      default_header = {
        'User-Agent' => 'TenablescClient::Request - rubygems.org tenablesc_client',
        'Content-Type' => 'application/json'
      }
      expect(
        TenablescClient::Request::DEFAULT_HEADERS
      ).to eq(default_header)
    end
  end

  context '.get' do
    it 'response has a body' do
      allow(TenablescClient::Request).to receive(
        :get
      ).and_return('RESPONSE_BODY')
      expect(
        TenablescClient::Request.get
      ).to eq('RESPONSE_BODY')
    end
    it 'default request/response' do
      allow_any_instance_of(TenablescClient::Request).to receive(
        :get
      ).and_return('RESPONSE_BODY')
      expect(
        @tenable_request.get
      ).to eq('RESPONSE_BODY')
    end
    it 'all parameters defined' do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).and_return(
        Excon::Response.new(
          {
            body: 'RESPONSE_BODY',
            status: 200
          }
        )
      )
      expect(
        @tenable_request.get(
          {
            path: 'path',
            payload: 'payload',
            query: 'query',
            format: 'JSON'
          }
        )
      ).to eq('RESPONSE_BODY')
    end
    it 'empty response' do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).and_return(Excon::Response.new({ body: '' }))
      expect(
        @tenable_request.get(format: 'JSON')
      ).to eq(nil)
    end
    it 'should raise Excon::Error exception' do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).and_raise(Excon::Error)
      expect {
        @tenable_request.get({ path: '/', format: 'JSON' })
      }.to raise_error(Excon::Error)
    end
  end

  context '.post' do
    it 'request with no parameters' do
      allow_any_instance_of(TenablescClient::Request).to receive(
        :post
      ).and_return('RESPONSE_BODY')
      expect(
        @tenable_request.post
      ).to eq('RESPONSE_BODY')
    end
    it 'request with json data' do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).and_return(Excon::Response.new({ body: 'RESPONSE_BODY' }))
      expect(
        @tenable_request.post({ path: '/', payload: '{"key":"data"}', format: 'JSON' })
      ).to eq('RESPONSE_BODY')
    end
  end

  context '.delete' do
    it 'request with no parameters' do
      allow_any_instance_of(TenablescClient::Request).to receive(
        :delete
      ).and_return('RESPONSE_BODY')
      expect(
        @tenable_request.delete
      ).to eq('RESPONSE_BODY')
    end
    it 'request with json data' do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).and_return(
        Excon::Response.new({ body: 'RESPONSE_BODY' })
      )
      expect(
        @tenable_request.delete({ path: '/', payload: '{"key":"data"}', format: 'JSON' })
      ).to eq('RESPONSE_BODY')
    end
  end
end
