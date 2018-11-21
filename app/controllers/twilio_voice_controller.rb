class TwilioVoiceController < ApplicationController
  include TwilioUtils

  respond_to :xml
  skip_before_action :verify_authenticity_token
  # before_action :validate_twilio_header

  # TODO: leave here, write tests, add route
  def replay
    @game = Game.find(params[:twilio_voice_id])
    @twiml_response = Twilio::TwiML::Response.new do |r|
      r.Say reply_body(@game.fizzbuzz_number || "5")
    end.text
    render :xml => @twiml_response, status: 201
  end

  def new
    fizzbuzz_params = {timeout: 10, finishOnKey: '#', action: '/twilio_voice', method: 'post', timeout: 10, finishOnKey: '#'}
    @twiml_response = Twilio::TwiML::Response.new do |r|
      r.Gather fizzbuzz_params do |g|
        r.Say 'Enter a number and press the pound key', :voice => 'alice'
      end
    end.text
    render :xml => @twiml_response, status: 200
  end

  def create
    @digits = params[:Digits]
    if @digits
      # TODO: strip the +1 off the front
      @game = Game.find_or_create_by(phone_number: params[:To])
      @game.update_attributes(fizzbuzz_number: @digits)
      response = Twilio::TwiML::Response.new { |r| r.Say reply_body(@digits) }.text
    else
      logger.error 'no digits parameter'
      head status: 500 and return
    end
    render :xml => response, status: 200
  end

  protected
  def validate_twilio_header
    signature_header = request.headers['X-Twilio-Signature'].presence
    signature_string = signature_string(ENV['TWILIO_TOKEN'], request.original_url, params, request.post?)
    unless signature_header && (signature_header == signature_string.chomp)
      ap sig_header: signature_header,calculated_string: signature_string
      render :xml => Twilio::TwiML::Response.new { |r|
        r.Say "Validation failed: #{signature_header} does not validate"
      }, status: 401 and return
    end
  end

  def reply_body(digits)
    body = ''
    (1..@digits.to_i).each do |digit|
      current_answer = ''
      current_answer << 'Fizz' if digit%3 == 0
      current_answer << 'Buzz' if digit%5 == 0
      current_answer = digit.to_s if current_answer.blank?
      body << current_answer + ','
    end
    body.chop!
  end

end