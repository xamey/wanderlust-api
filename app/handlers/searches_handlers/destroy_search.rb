module SearchesHandlers
  class DestroySearch < AsyncHandler
    include HandlerCommon

    def run
      search = Search.find(data[:id])
      if search.user_id == data[:user_id]
        search.destroy!
        event_store.publish(SearchDestroyed.new(data: { search_id: search.id }))
      else
        raise "User #{data[:user_id]} can't destroy search #{data[:id]}"
      end
    end

    def should_run?
      Search.exists?(id: data[:id]) && User.exists?(id: data[:user_id])
    end
  end
end
