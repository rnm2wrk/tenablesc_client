# frozen_string_literal: true

# Namespace for Asset resource.
module Resource::Asset

  # Get list of assets by an IP Address.
  # @param [String] asset_ip The IP Address of the asset.
  # @param [Integer] limit The limit of possible returned results.
  # @return [Hash] List of matched assets.
  def search_asset_by_ip(asset_ip, limit = 20)
    request.get({ path: "/rest/search/hostAsset", headers: headers, payload: {
      'type' => 'ipAddress',
      'query' => "#{asset_ip}",
      'limit' => "#{limit}"
    }, format: 'JSON' })['response']
  end

  # Get asset info by its UUID.
  # @param [String] asset_uuid The uuid of an asset.
  # @param [Integer] limit The limit of possible returned results.
  # @return [Hash] Asset info.
  def get_asset_info_by_uuid(asset_uuid, limit = 20)
    request.get({ path: "/rest/search/hostAsset/details", headers: headers, payload: {
      'hostUUID' => "#{asset_uuid}",
      'saveHistory' => "true"
    }, format: 'JSON' })['response']
  end

  # Get asset info by its IP Address.
  # @param [String] asset_ip The IP Address of an asset.
  # @param [Integer] limit The limit of possible returned results.
  # @return [Hash] Asset info.
  def get_asset_info_by_ip(asset_ip, limit = 20)
    resp = search_asset_by_ip(asset_ip)

    if resp['count'] > 0
      resp['results'].each do |hash|
        if hash['ipAddress'].match?(asset_ip)
          return get_asset_info_by_uuid(hash['uuid'])
        end
      end
    else
      resp
    end      
  end

  # Get vulnerability list from an asset IP Address.
  def get_vulns_by_asset_ip(asset_ip, limit = 10, source = 'cumulative')
    return
  end
end
