module SearchesHandler
  class SetSearchAsFavorite < AsyncHandler
    include HandlerCommon

    def run
      search = Search.find(data[:id])
      search.update!(favorite: true)
      event_store.publish_event(
        SearchSetAsFavorite.new(data: { search_id: search.id })
      )
    end

    def should_run?
      Search.exists?(id: data[:id])
    end
  end
end
