class SearchesController < ApplicationController
  def index
    proxy_request
  end

  def create
    if params[:tags].is_a?(Array) && params[:city].is_a?(String)
      event =
        CreateSearch.new(
          data: {
            tags: params[:tags],
            city: params[:city],
            user_id: current_user.id
          }
        )
      event_store.publish_event(event)

      render json: { message: "Search created" }, status: :created
    else
      render json: { error: "Invalid payload" }, status: :unprocessable_entity
    end
  end

  def favorite
    if params[:id].is_a?(String)
      event = SetSearchAsFavorite.new(data: { id: params[:id] })
      event_store.publish_event(event)

      render json: { message: "Search set as favorite" }, status: :ok
    else
      render json: { error: "Invalid payload" }, status: :unprocessable_entity
    end
  end

  def unfavorite
    if params[:id].is_a?(String)
      event = SetSearchAsUnfavorite.new(data: { id: params[:id] })
      event_store.publish_event(event)

      render json: { message: "Search set as unfavorite" }, status: :ok
    else
      render json: { error: "Invalid payload" }, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:id].is_a?(String)
      event = DestroySearch.new(data: { id: params[:id] })
      event_store.publish_event(event)

      render json: { message: "Search destroyed" }, status: :ok
    else
      render json: { error: "Invalid payload" }, status: :unprocessable_entity
    end
  end

  private

  def event_store
    Rails.configuration.event_store
  end

  def proxy_request
  end
end
