class DecksController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        render json: [].to_json, status: :ok
      end
    end
  end

  def create
    respond_to do |format|
      format.json do
        head :no_content
      end
    end
  end
end
