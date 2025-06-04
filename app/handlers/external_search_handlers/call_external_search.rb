require Rails.root.join("lib/llm")

module ExternalSearchHandlers
  class CallExternalSearch < AsyncHandler
    include HandlerCommon

    def run
      search = Search.find(data[:search_id])
      search.update!(status: :researching)

      begin
        search_results = LLM.get_search_results(search.tags)
        ActiveRecord::Base.transaction do
          search_results.each do |result|
            SearchResult.create!(
              search: search,
              title: result[:title],
              favorite: false,
              description: result[:description]
            )
          end
          search.update!(status: :success)
        end
      rescue LLM::LLMCallError,
             ActiveRecord::Rollback,
             ActiveRecord::RecordInvalid => _
        search.update!(status: :failed)
      end
    end

    def should_run?
      Search.exists?(id: data[:search_id])
    end
  end
end
