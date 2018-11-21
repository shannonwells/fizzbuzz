require 'rails_helper'

describe HomeController, :type => :controller do
  render_views

  describe 'GET index' do
    subject { get 'index'}
    it { should be_success }
    it { should render_template :index}
  end

  describe 'POST initiate_replay' do
    subject { post 'initiate_replay'}
  end

  describe 'POST call phone' do
    subject { post 'call_phone', phone_number: '650-954-5671', delay: 0 }
    it { should be_redirect }
  end

end