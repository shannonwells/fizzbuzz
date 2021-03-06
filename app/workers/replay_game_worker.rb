class ReplayGameWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true

  def perform(game_id)
    @game = Game.find game_id
    account_sid = ENV['TWILIO_SID']
    auth_token = ENV['TWILIO_TOKEN']

    @client = Twilio::REST::Client.new account_sid, auth_token

    @client.account.calls.create({
           :to => @game.phone_number,
           :from => '+16502784882',
           :url => "http://#{ENV['FQDN']}/twilio_voice/#{@game.id}/replay",
           :application_sid => ENV['TWILIO_APP_ID'],
           :method => 'POST',
           :fallback_method => 'GET',
           :status_callback_method => 'GET',
           :record => 'false'
       })
  end
end
