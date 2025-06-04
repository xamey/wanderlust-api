require "json"

require "llm/api_client"
require_relative "llm/search_results"

module LLM
  class LLMCallError < StandardError
    def initialize(message)
      super(message)
    end
  end

  class << self
    def client
      @client ||= LLM::ApiClient.new
    end

    def get_search_results(user_prompt)
      # LLM::SearchResults.new(client, user_prompt).call
      [{ title: "Test", description: "Test" }]
    end
  end
end
