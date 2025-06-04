module SearchesHandler
  class SetSearchAsNotFavorite < AsyncHandler
    include HandlerCommon

    def run
      search = Search.find(data[:id])
      search.update!(favorite: false)
      event_store.publish_event(
        SearchSetAsNotFavorite.new(data: { search_id: search.id })
      )
    end

    def should_run?
      Search.exists?(id: data[:id])
    end
  end
end
