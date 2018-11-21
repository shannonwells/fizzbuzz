require 'spec_helper'

describe TwilioVoiceController, type: :controller do
  describe 'POST replay' do
    before do
      allow(controller).to receive(:validate_twilio_header) { true }
    end

    let(:game ){       Game.create(phone_number: '5551212', delay_minutes: 0)
    }

    it 'works' do
      post "replay", twilio_voice_id: game.id
      response.body.should include 'Say'
    end
  end

  describe "GET 'new'" do
    before do
      allow(controller).to receive(:validate_twilio_header) { true }
    end
    it 'requires a phone number' do
      get 'new', format: :xml
      # response.should render_template 'home/index'
      response.should be_success
      response.body.should include 'Say'
    end
  end

  describe "POST 'create'" do
    before do
      Game.create(phone_number: '5551212', delay_minutes: 0)
      allow(controller).to receive(:validate_twilio_header) { true }
    end
    it "works" do
      post 'create', :Digits =>  "15", :To => '5551212', :format => :xml
      expect(response).to be_success
      expect(response.body).to include '1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz'
    end

    it 'requires Digits parameter' do
      post 'create', :format => :xml
      expect(response.status).to eql 500
    end

  end

  describe 'header authentication' do
    it 'fails if header is missing' do
      get 'new', format: :xml
      expect(response.body).to be_blank
      expect(response.status).to eql 401
    end
    it 'must pass the header authentication' do
      request.headers['X-Twilio-Signature'] = "39tcJuTprEFRK3wBtCbW/bVT708=\n"
      post 'create', :format => :xml, :CallSid => "foo", :Digits => "15#"
      expect(response.body).to be_blank
      expect(response.status).to eql 401
    end
  end

end
