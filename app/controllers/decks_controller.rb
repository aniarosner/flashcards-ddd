class DecksController < ApplicationController
  def create
    respond_to do |format|
      format.json do
        head :no_content
      end
    end
  end
end
