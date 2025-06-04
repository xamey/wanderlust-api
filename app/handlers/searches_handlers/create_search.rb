module SearchesHandlers
  class CreateSearch < AsyncHandler
    include HandlerCommon

    def run
      search =
        Search.create!(
          tags: data[:tags],
          city: data[:city],
          user_id: data[:user_id],
          status: :pending
        )

      event_store.publish(SearchCreated.new(data: { search_id: search.id }))
    end

    def should_run?
      data[:tags].is_a?(Array) && data[:city].is_a?(String) &&
        data[:user_id].is_a?(Integer) && User.exists?(id: data[:user_id])
    end
  end
end
