class CardsController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: [], status: :ok }
    end
  end
end
