module HandlerCommon
  extend ActiveSupport::Concern

  def event_store
    Rails.configuration.event_store
  end

  def data
    @event.data
  end

  def should_run?
    raise "The method 'should_run?' must be implemented in the subclass"
  end

  def run
    raise "The method 'run' must be implemented in the subclass"
  end
end
