require 'rails_helper'
require 'sidekiq/testing'

describe CallPhoneWorker do
  it 'works' do
    game = Game.create(phone_number: '5551212', delay_minutes: 1)
    allow(Twilio::REST::Client).to receive(:new) { game }
    CallPhoneWorker.new.perform(game.id)
  end

end