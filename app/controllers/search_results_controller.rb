class SearchResultsController < ApplicationController
  include ElectricSql

  def index
    proxy_request_to_electric_sql("search_results") do
      "\"search_id\" IN (SELECT id FROM searches WHERE user_id = #{current_user.id})"
    end
  end

  def favorite
    if params[:id].is_a?(String)
      event =
        SetSearchResultAsFavorite.new(
          data: {
            search_result_id: params[:id],
            user_id: current_user.id
          }
        )
      event_store.publish(event)

      render json: { message: "Search set as favorite" }, status: :ok
    else
      render json: { error: "Invalid payload" }, status: :unprocessable_entity
    end
  end

  def unfavorite
    if params[:id].is_a?(String)
      event =
        SetSearchResultAsUnfavorite.new(
          data: {
            search_result_id: params[:id],
            user_id: current_user.id
          }
        )
      event_store.publish(event)

      render json: { message: "Search set as unfavorite" }, status: :ok
    else
      render json: { error: "Invalid payload" }, status: :unprocessable_entity
    end
  end

  private

  def event_store
    Rails.configuration.event_store
  end
end
