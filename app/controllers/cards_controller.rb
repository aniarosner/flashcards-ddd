class CardsController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        render json: Cards::ReadModel.new.from_deck(params[:deck_uuid]).as_json(except: :deck_uuid), status: :ok
      end
    end
  end

  def create
    respond_to do |format|
      command_bus.call(
        Content::AddCardToDeck.new(deck_uuid: params[:deck_uuid], front: params[:front], back: params[:back])
      )
      format.json { head :no_content }
    end
  end
end
