# frozen_string_literal: true

# Namespace for Server resource.
module Resource::Server
  # Returns the server status.
  # @return [Hash] Returns the server status
  def server_status
    request.get({ path: '/rest/status', headers: headers, format: 'JSON' })
  end

  # @return [Hash] Returns the zones status
  def scanner_status
    server_status['response']['zones']
  end
end
