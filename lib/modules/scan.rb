# frozen_string_literal: true

# Namespace for Scan resource.
module Resource::Scan
  # Returns the list of scans
  # @return [Hash] Returns the list of scan status
  def get_scans
    request.get({ path: '/rest/scanResult', headers: headers, format: 'JSON' })['response']
  end
end
