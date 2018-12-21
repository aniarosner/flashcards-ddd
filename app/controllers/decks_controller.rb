class DecksController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        render json: Decks::ReadModel.new.from_course(params[:course_uuid]).as_json(except: :course_uuid), status: :ok
      end
      format.html do
        render action: :index, locals: {
          course: Courses::ReadModel.new.find(params[:course_uuid]),
          decks: Decks::ReadModel.new.from_course(params[:course_uuid])
        }
      end
    end
  end

  def create
    respond_to do |format|
      command_bus.call(
        Content::CreateDeckInCourse.new(deck_uuid: params[:deck_uuid], course_uuid: params[:course_uuid])
      )
      command_bus.call(Content::SetDeckTitle.new(deck_uuid: params[:deck_uuid], title: params[:title]))

      format.json { head :no_content }
      format.html { redirect_to course_decks_path }
    end
  end

  def new
    deck_uuid = SecureRandom.uuid

    respond_to do |format|
      format.html { render action: :new, locals: { deck_uuid: deck_uuid } }
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        command_bus.call(Content::RemoveDeck.new(deck_uuid: params[:deck_uuid], course_uuid: params[:course_uuid]))

        head :no_content
      end
    end
  end

  def cards
    respond_to do |format|
      format.json do
        render json: Cards::ReadModel.new.from_deck(params[:deck_uuid]).as_json(except: %i[deck_uuid uuid]), status: :ok
      end
      format.html do
        render action: :cards, locals: {
          deck: Decks::ReadModel.new.find(params[:deck_uuid]),
          cards: Cards::ReadModel.new.from_deck(params[:deck_uuid])
        }
      end
    end
  end

  def add_card
    respond_to do |format|
      command_bus.call(
        Content::AddCardToDeck.new(deck_uuid: params[:deck_uuid], front: params[:front], back: params[:back])
      )
      format.json { head :no_content }
      format.html { redirect_to cards_deck_path }
    end
  end

  def new_card
    respond_to do |format|
      format.html { render action: :new_card, locals: { deck_uuid: params[:deck_uuid] } }
    end
  end

  def remove_card
    command_bus.call(
      Content::RemoveCardFromDeck.new(deck_uuid: params[:deck_uuid], front: params[:front], back: params[:back])
    )
    respond_to do |format|
      format.json { head :no_content }
      format.html { redirect_to cards_deck_path }
    end
  end
end
