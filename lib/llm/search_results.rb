module LLM
  class SearchResultsFromLLMResponse
    attr_reader :test

    def initialize(response)
    end
  end

  class SearchResults
    def initialize(client, user_prompt)
      @client = client

      raise "user_prompt not implemented" unless user_prompt
      @user_prompt = user_prompt
    end

    def call
      search_results =
        @client.call(prompt(@user_prompt), response_format)["search_results"]
      LLM::SearchResultsFromLLMResponse.new(search_results)
    end

    private

    def prompt(user_prompt)
      [
        {
          role: "system",
          content: [
            {
              type: "text",
              text:
                "Voici le message d'un patient: '#{user_prompt}'. " \
                  "En se basant sur des livres de psychiatrie reconnus, le message contient-il des signes de dépression ? De phase " \
                  "maniaque ? Des idées suicidaires ?"
            }
          ]
        }
      ]
    end

    def response_format
      {
        type: "json_schema",
        json_schema: {
          name: "behaviours",
          strict: true,
          schema: {
            type: "object",
            properties: {
              behaviours: {
                type: "object",
                properties: {
                  depression: {
                    type: "boolean"
                  },
                  mania: {
                    type: "boolean"
                  },
                  suicide_idea: {
                    type: "boolean"
                  }
                },
                required: %w[depression mania suicide_idea],
                additionalProperties: false
              }
            },
            required: ["behaviours"],
            additionalProperties: false
          }
        }
      }
    end
  end
end
