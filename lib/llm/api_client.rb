require "net/http"
require "json"
require "uri"

module LLM
  class ApiClient
    ENDPOINT = "https://openrouter.ai/api/v1/chat/completions"
    MODEL = "google/gemini-2.5-flash-preview"

    def initialize
      @api_key = ENV["OPENROUTER_API_KEY"]
      raise "OPENROUTER_API_KEY not set" unless @api_key
    end

    def call(prompt, response_format = nil)
      raise "prompt not implemented" unless prompt

      uri = URI(ENDPOINT)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{@api_key}"
      }

      body = { model: MODEL, messages: prompt }

      body[:response_format] = response_format if response_format.present?

      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = body.to_json

      response = http.request(request)
      json = JSON.parse(response.body)
      content = json["choices"][0]["message"]["content"]
      response_format.present? ? JSON.parse(content) : content
    end
  end
end
