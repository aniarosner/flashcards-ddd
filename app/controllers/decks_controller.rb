class DecksController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        render json: DeckListReadModel.new.from_course(params[:course_uuid]).as_json(except: :course_uuid), status: :ok
      end
    end
  end

  def create
    respond_to do |format|
      format.json do
        command_bus.call(Content::AddDeckToCourse.new(deck_uuid: params[:deck_uuid], course_uuid: params[:course_uuid]))

        head :no_content
      end
    end
  end
end
