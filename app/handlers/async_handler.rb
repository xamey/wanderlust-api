class AsyncHandler < ActiveJob::Base
  prepend RailsEventStore::AsyncHandler
  include HandlerCommon

  def perform(event)
    @event = event

    run if should_run?
  end
end
