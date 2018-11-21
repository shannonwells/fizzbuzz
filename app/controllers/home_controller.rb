class HomeController < ApplicationController
  def index
    @games = Game.all
  end

  def initiate_replay
    @game = Game.find(params[:id])
    if @game.nil?
      flash[:error] = "Could not find this game"
    end
    ReplayGameWorker.perform_async(params[:id])
    flash[:info]="You sent a replay to #{@game.phone_number}"
    redirect_to :root
  end

  def call_phone
    @phone_number = params[:phone_number].gsub(/[^0-9]/, '') # remove any formatting
    @delay = params[:delay].to_i

    # Form takes care of other validations client-side.
    if @phone_number.length < 7
      flash.now[:error] = 'That phone number is not valid.'
      render home_index_path and return
    elsif @delay > 10
      flash.now[:error] = 'Cannot set a delay longer than 10 minutes.'
      render home_index_path and return
    end
    # store a record of the call/game
    game = Game.create(phone_number: @phone_number, delay_minutes: @delay)
    if game.persisted?
      CallPhoneWorker.perform_in(@delay, game.id)
      flash[:info]="You sent an invitation to play FizzBuzz to #{@phone_number}"
    else
      flash[:error] = "There was an unexpected problem, and your game can't be initiated."
    end
    redirect_to :root
  end


end
