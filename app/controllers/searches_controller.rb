class SearchesController < ApplicationController
  include ElectricSql

  def index
    proxy_request_to_electric_sql("searches") do
      "\"user_id\" = #{current_user.id}"
    end
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
      event_store.publish(event)

      render json: { message: "Search created" }, status: :created
    else
      render json: { error: "Invalid payload" }, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:id].is_a?(String)
      event =
        DestroySearch.new(data: { id: params[:id], user_id: current_user.id })
      event_store.publish(event)

      render json: { message: "Search destroyed" }, status: :ok
    else
      render json: { error: "Invalid payload" }, status: :unprocessable_entity
    end
  end

  private

  def event_store
    Rails.configuration.event_store
  end
end
