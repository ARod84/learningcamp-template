require 'rails_helper'

RSpec.describe 'Preferences', type: :request do
  let!(:user) { User.create(email: 'user@example.com', password: 'password') }
  let!(:preference) do
    Preference.create(name: 'Sample Preference', description: 'This is a sample preference.', restriction: 'None')
  end

  before do
    sign_in user # Assuming Devise for authentication
  end

  describe 'GET /preferences/:id' do
    context 'when the preference exists' do
      it 'returns the preference details' do
        get "/preferences/#{preference.id}"

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          'name' => 'Sample Preference',
          'description' => 'This is a sample preference.',
          'restriction' => true
        )
      end
    end

    context 'when the preference does not exist' do
      it 'returns a 404 not found' do
        get '/preferences/9999'

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Preference not found')
      end
    end
  end
end
