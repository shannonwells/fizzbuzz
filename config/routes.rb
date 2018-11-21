require 'sidekiq/web'
Rails.application.routes.draw do
  get 'home/index'

  namespace :home do
    post 'initiate_replay', to: :initiate_replay
    post 'call_phone', to: :call_phone
  end

  resources :twilio_voice, :only => [:new, :create] do
    post 'replay', to: 'twilio_voice#replay'
  end

  root to: 'home#index'
  # mount Sidekiq::Web => '/sidekiq'
end
