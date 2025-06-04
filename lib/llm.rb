require "json"

require "llm/api_client"

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

    def get_behaviours(user_prompt)
      LLM::Behaviours.new(client, user_prompt).call
    end

    def analyse_conversation(session_id)
      LLM::ConversationAnalysis.new(client, session_id).call
    end
  end
end
