module SearchesHandler
  class DestroySearch < AsyncHandler
    include HandlerCommon

    def run
      search = Search.find(data[:id])
      search.destroy!
      event_store.publish_event(
        SearchDestroyed.new(data: { search_id: search.id })
      )
    end

    def should_run?
      Search.exists?(id: data[:id])
    end
  end
end
