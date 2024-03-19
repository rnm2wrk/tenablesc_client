# frozen_string_literal: true

# Namespace for Session resource.
module Resource::Session
  # @return [Boolean] whether has a session.
  attr_reader :session

  @session = false

  # Autenticate into Tenable Security Center resource using username and password.
  # @param [String] username
  # @param [String] password
  # @return [nil]
  # @raise [TenablescClient::Error] Unable to authenticate.
  # @raise [TenablescClient::Error] When X-Securitycenter token is invalid formatted.
  def set_session_userpass(username, password)

    return if username.nil? || password.nil?
    raise TenablescClient::Error, 'Session already established.' if @session

    payload = {
      username: username,
      password: password
    }

    resp = request.post({ path: '/rest/token', payload: payload, headers: headers.except('x-apikey', 'Cookie', 'X-Securitycenter') })
    
    if resp[:status] != 200
      raise TenablescClient::Error, "Unable to authenticate. Error: #{resp[:body]}"
    end
    
    x_securitycenter_token = JSON.parse(resp[:body])['response']['token']
    if !x_securitycenter_token.to_s.match(/[0-9]{10}/)
      raise TenablescClient::Error, 'The token doesnt match with the pattern.'
    end
    
    tns_cookie = get_tns_session_cookie(resp[:cookies])
    headers.update('Cookie' => tns_cookie)
    headers.update('X-Securitycenter' => x_securitycenter_token)
    @session = true
    
    check_session

    rescue TenablescClient::Error => e
      raise e
    end
  alias session_create_userpass set_session_userpass


  # Autenticate into Tenable Security Center resource using API keys.
  # @param [String] access_key
  # @param [String] secret_key
  # @return [nil]
  # @raise [TenablescClient::Error] Unable to authenticate.
  def set_session_keys(access_key, secret_key)
    
    return if access_key.nil? || secret_key.nil?
    raise TenablescClient::Error, 'Session already established.' if @session

    headers.update('x-apikey' => "accesskey=#{access_key}; secretkey=#{secret_key};")
    @session = true

    check_session
    
    rescue TenablescClient::Error => e
      raise e
    end
  alias session_create_keys set_session_keys

  def check_session
    raise TenablescClient::Error, 'There is no session established.' unless @session

    resp = request.get({ path: '/rest/status', headers: headers })

    if resp[:status] != 200
      headers.delete('Cookie')
      headers.delete('X-Securitycenter')
      headers.delete('x-apikey')
      @session = false
      raise TenablescClient::Error, "Established session is not valid. Error: #{resp[:body]}"
    end
    true
  end
  # Destroy the current session. TODO
  def destroy
    request.delete({ path: '/rest/token', headers: headers })
    @session = false
    end
  alias logout destroy

  private

  def get_tns_session_cookie(cookies = [])
    return '' if cookies.to_a.empty?
    cookies.select{ |a| a.split(';')[0].include? 'TNS_SESSIONID'}.first.split(';')[0]
  end
end
