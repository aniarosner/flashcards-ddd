class CardsController < ApplicationController
  

  def create
    respond_to do |format|
      command_bus.call(
        Content::AddCardToDeck.new(deck_uuid: params[:deck_uuid], front: params[:front], back: params[:back])
      )
      format.json { head :no_content }
    end
  end
end
