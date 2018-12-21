class CardsController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: [], status: :ok }
    end
  end

  def create
    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
