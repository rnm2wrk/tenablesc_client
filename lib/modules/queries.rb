# frozen_string_literal: true

# Namespace for Queries resource.
module Resource::Queries
  # List the queries.
  # @return [Hash] list of queries.
  def queries
    request.get({ path: '/rest/query', headers: headers, format: 'JSON' })['response']
  end

  # Get id of a query by its name.
  # @param [String] query_name The name of the query.
  # @return [Integer] ID of a query.
  def get_query_id_by_name(query_name)
    queries['usable'].each do |query|
      return query['id'] if query['name'] == query_name
    end
  end

  def get_query_info(query_id)
    request.get({ path: "/rest/query/#{query_id}", headers: headers, format: 'JSON' })['response']
  end
  # Get a query result by its name.
  # @param [String] query_name The name of the query.
  # @param [Integer] s_offset start offset of returned information from query
  # @param [Integer] e_offset end offset of returned information from query
  # @param [String] source source type of query
  # @return [Hash] A query object.
  def get_vulns_by_query_name(query_name, s_offset = 0, e_offset = 50, source = 'cumulative')
    query_id = get_query_id_by_name(query_name)
    query_info = get_query_info(query_id)
    params = 
    { 
      'query' => {
          'name' => query_info['name'],
          'tool' => query_info['tool'],
          'type' => query_info['type'],
          'filters' => query_info['filters'],
          'sourceType' => source,
          'startOffset' => s_offset,
          'endOffset' => e_offset
      },
      'type' => query_info['type'],
      'sourceType' => source
    }

    request.post({ path: '/rest/analysis', headers: headers, payload: params, format: 'JSON' })['response']
  end
end
