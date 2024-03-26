# frozen_string_literal: true

# Namespace for Asset resource.
module Resource::Asset
  # Get list of assets similar to an IP Address.
  # @param [String] asset_ip The IP Address of the asset.
  # @param [Integer] limit The limit of possible returned results.
  # @return [Hash] List of matched assets.
  def search_asset_by_ip(asset_ip, limit = 20)
    request.get({ path: '/rest/search/hostAsset', headers: headers, payload: {
                  'type' => 'ipAddress',
                  'query' => asset_ip.to_s,
                  'limit' => limit.to_s
                }, format: 'JSON' })['response']
  end
  # Get asset info by its UUID.
  # @param [String] asset_uuid The uuid of an asset.
  # @param [Integer] limit The limit of possible returned results.
  # @return [Hash] Asset info.
  def get_asset_info_by_uuid(asset_uuid)
    request.get({ path: '/rest/search/hostAsset/details', headers: headers, payload: {
                  'hostUUID' => asset_uuid.to_s,
                  'saveHistory' => 'true'
                }, format: 'JSON' })['response']
  end
  # Get asset info by its IP Address.
  # @param [String] asset_ip The IP Address of an asset.
  # @param [Integer] limit The limit of possible returned results.
  # @return [Hash] Asset info.
  def get_asset_info_by_ip(asset_ip, _limit = 20)
    resp = search_asset_by_ip(asset_ip)
    if (resp['count']).positive?
      resp['results'].each do |hash|
        return get_asset_info_by_uuid(hash['uuid']) if hash['ipAddress'].match?(asset_ip)
      end
    end
    { 'count' => 0, 'results' => [] }
  end
  # Get vulnerability list from an asset IP Address.
  # @param [String] asset_ip The ip address of a query
  # @param [Integer] s_offset start offset of returned information
  # @param [Integer] e_offset end offset of returned information
  # @param [String] source source type of query
  # @return [Hash] A query object.
  def get_vulns_by_asset_ip(asset_ip, s_offset = 0, e_offset = 50, source = 'cumulative')
    params =
      {
        'query' => {
          'tool' => 'vulndetails',
          'type' => 'vuln',
          'filters' => [
            'filterName' => 'ip',
            'operator' => '=',
            'value' => asset_ip
          ],
          'sourceType' => source,
          'startOffset' => s_offset,
          'endOffset' => e_offset
        },
        'type' => 'vuln',
        'sourceType' => source
      }
    request.post({ path: '/rest/analysis', headers: headers, payload: params, format: 'JSON' })['response']
  end
end
