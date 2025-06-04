class SyncHandler
  include HandlerCommon

  def call(event)
    @event = event

    run if should_run?
  end
end
