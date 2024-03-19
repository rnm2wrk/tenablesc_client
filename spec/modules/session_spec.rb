# frozen_string_literal: true

require_relative '../spec_helper'

describe Resource::Session do
  before(:context) do
    RSpec::Mocks.with_temporary_scope do
      
      x_securitycenter_regex = Regexp.new('[0-9]{10}')
      @x_securitycenter_string = x_securitycenter_regex.random_example
      cookie_regex = Regexp.new('[a-z0-9]{32}')
      keys_regex = Regexp.new('[a-z0-9]{32}')
      @cookie_string = cookie_regex.random_example
      @access_key_string = keys_regex.random_example
      @secret_key_string = keys_regex.random_example
      @mock_xsecuritycenter_token_body = "{\"response\":{\"token\":#{@x_securitycenter_string}}}"
      @mock_fail_xsecuritycenter_token_body = "{\"response\":{\"token\":\"a\"}}"
      
      @userpass = {
        username: 'username',
        password: 'password'
      }
      @keys = {
        access_key: @access_key_string,
        secret_key: @secret_key_string
      }
    end
  end

  context 'successfully initialize with userpass' do
    before :each do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).with(
        {
          body: '{"username":"username","password":"password"}',
          headers: {
            'Content-Type' => 'application/json',
            'User-Agent' => 'TenablescClient::Request - rubygems.org tenablesc_client'
          },
          method: :post,
          path: '/rest/token',
          query: nil
        }
      ).and_return(
        Excon::Response.new({ 
          status: 200,
          cookies: ["TNS_SESSIONID=#{@cookie_string}; path=/; secure; HttpOnly;"],
          headers: {
           'Set-Cookie' => "TNS_SESSIONID=#{@cookie_string}; path=/; secure; HttpOnly;"
          },
          body: @mock_xsecuritycenter_token_body          
        })
      )
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).with(
        {
          headers: {
            'Content-Type' => 'application/json',
            'User-Agent' => 'TenablescClient::Request - rubygems.org tenablesc_client',
            'Cookie' => "TNS_SESSIONID=#{@cookie_string}",
            'X-Securitycenter' => @x_securitycenter_string.to_i
          },
          body: '',
          method: :get,
          path: '/rest/status',
          query: nil
        }
      ).and_return(
        Excon::Response.new({ 
          status: 200        
        })
      )
      allow_any_instance_of(TenablescClient).to receive(
        :new
      ).and_return(
        TenablescClient.new(@userpass)
      )
      @tsc_client = TenablescClient.new(@userpass)
    end
    it 'session has been create' do
      expect(@tsc_client.has_session?).to be_truthy
    end

    it 'has a token' do
      expect(@tsc_client.session.nil?).to be_falsy
    end

    it 'expect token string value' do
      expect(@tsc_client.headers).to have_key('Cookie')
      expect(@tsc_client.headers).to have_key('X-Securitycenter')
      expect(@tsc_client.headers['Cookie']).to eql("TNS_SESSIONID=#{@cookie_string}")
      expect(@tsc_client.headers['X-Securitycenter']).to eql(@x_securitycenter_string.to_i)
    end

    it 'token should be nil after logout' do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).and_return(Excon::Response.new({ 
          status: 200,
          headers: {
            'Set-Cookie' => "TNS_SESSIONID=#{@cookie_string}; path=/; secure; HttpOnly;"
          },
          body: @mock_xsecuritycenter_token_body
        }))
      allow_any_instance_of(TenablescClient).to receive(
        :new
      ).and_return(
        TenablescClient.new(@userpass)
      )
      tsc_client = TenablescClient.new(@userpass)
      tsc_client.logout
      expect(
        tsc_client.session
      ).to be_falsy
    end
  end

  context 'unsuccessfully initialize with userpass' do
    it 'has NOT session token' do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).with(
        {
          body: '{"username":"username","password":"password"}',
          headers: {
            'Content-Type' => 'application/json',
            'User-Agent' => 'TenablescClient::Request - rubygems.org tenablesc_client'
          },
          method: :post,
          path: '/rest/token',
          query: nil
        }
      ).and_return(
        Excon::Response.new(
          {
            status: 401
          }
        )
      )
      expect {
        TenablescClient.new(@userpass)
      }.to raise_error(TenablescClient::Error)
    end

    it 'has badly formatted X-Securitycenter token' do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).with(
        {
          body: '{"username":"username","password":"password"}',
          headers: {
            'Content-Type' => 'application/json',
            'User-Agent' => 'TenablescClient::Request - rubygems.org tenablesc_client'
          },
          method: :post,
          path: '/rest/token',
          query: nil
        }
      ).and_return(
        Excon::Response.new(
          {
            status: 200,
            body: @mock_fail_xsecuritycenter_token_body
          }
        )
      )
      expect {
        TenablescClient.new(@userpass)
      }.to raise_error(TenablescClient::Error)
    end
  end

  context 'successfully initialize with keys' do
    before :each do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).with(
        {
          headers: {
            'Content-Type' => 'application/json',
            'User-Agent' => 'TenablescClient::Request - rubygems.org tenablesc_client',
            'x-apikey' => "accesskey=#{@access_key_string}; secretkey=#{@secret_key_string};"
          },
          body: '',
          method: :get,
          path: '/rest/status',
          query: nil
        }
      ).and_return(
        Excon::Response.new({ 
          status: 200        
        })
      )
      allow_any_instance_of(TenablescClient).to receive(
        :new
      ).and_return(
        TenablescClient.new(@keys)
      )
      @tsc_client = TenablescClient.new(@keys)
    end
    it 'session has been create' do
      expect(@tsc_client.has_session?).to be_truthy
    end

    it 'has a token' do
      expect(@tsc_client.session.nil?).to be_falsy
    end

    it 'expect token string value' do
      expect(@tsc_client.headers).to have_key('x-apikey')
      expect(@tsc_client.headers['x-apikey']).to eql("accesskey=#{@access_key_string}; secretkey=#{@secret_key_string};")
    end

    it 'token should be nil after logout' do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).and_return(Excon::Response.new({ 
          status: 200,
          headers: {
            'Set-Cookie' => "TNS_SESSIONID=#{@cookie_string}; path=/; secure; HttpOnly;"
          },
          body: @mock_xsecuritycenter_token_body
        }))
      allow_any_instance_of(TenablescClient).to receive(
        :new
      ).and_return(
        TenablescClient.new(@userpass)
      )
      tsc_client = TenablescClient.new(@userpass)
      tsc_client.logout
      expect(
        tsc_client.session
      ).to be_falsy
    end
  end
end
