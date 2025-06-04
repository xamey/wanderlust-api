module SearchResultsHandlers
  class SetSearchResultAsFavorite < AsyncHandler
    include HandlerCommon

    def run
      search_result = SearchResult.find(data[:search_result_id])
      if search_result.search.user_id == data[:user_id]
        search_result.update!(favorite: true)
      else
        raise "User #{data[:user_id]} can't set search result #{data[:search_result_id]} as favorite"
      end
    end

    def should_run?
      SearchResult.exists?(id: data[:search_result_id]) &&
        User.exists?(id: data[:user_id])
    end
  end
end
