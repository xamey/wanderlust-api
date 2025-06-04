require "rails_event_store"
require "aggregate_root"
require "arkency/command_bus"

Rails.configuration.to_prepare do
  event_store = RailsEventStore::Client.new
  Rails.configuration.event_store = event_store
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  event_store.subscribe_to_all_events(RailsEventStore::LinkByEventType.new)
  event_store.subscribe_to_all_events(RailsEventStore::LinkByCorrelationId.new)
  event_store.subscribe_to_all_events(RailsEventStore::LinkByCausationId.new)

  handlers = {
    SearchesHandlers::CreateSearch => %w[CreateSearch],
    SearchesHandlers::DestroySearch => %w[DestroySearch],
    ExternalSearchHandlers::CallExternalSearch => %w[SearchCreated],
    SearchResultsHandlers::SetSearchResultAsFavorite => %w[
      SetSearchResultAsFavorite
    ],
    SearchResultsHandlers::SetSearchResultAsNotFavorite => %w[
      SetSearchResultAsUnfavorite
    ]
  }

  handlers.each do |handler, events|
    events.each do |event|
      new_class = Class.new(RailsEventStore::Event)
      Object.const_set(event, new_class) if !Object.const_defined?(event)
    end

    event_store.subscribe(handler, to: events)
  end
end
