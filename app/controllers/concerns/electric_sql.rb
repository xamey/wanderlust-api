module ElectricSql
  extend ActiveSupport::Concern

  ELECTRIC_SQL_URL = "http://localhost:3000/v1/shape"

  def proxy_request_to_electric_sql(path, &block)
    origin_url = URI.parse("#{ELECTRIC_SQL_URL}/#{path}")

    allowed_params = %w[live table handle offset cursor]
    request.query_parameters.each do |key, value|
      if allowed_params.include?(key)
        origin_url.query = [origin_url.query, "#{key}=#{value}"].compact.join(
          "&"
        )
      end
    end

    where_clause = yield
    origin_url.query = [
      origin_url.query,
      "where=#{CGI.escape(where_clause)}"
    ].compact.join("&")

    response = Net::HTTP.get_response(origin_url)

    headers = response.to_hash
    headers.delete("content-encoding")
    headers.delete("content-length")

    render body: response.body,
           status: response.code,
           content_type: response.content_type,
           headers: headers
  end
end
