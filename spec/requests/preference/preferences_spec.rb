# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Preferences' do
  let!(:user) { User.create(email: 'user@example.com', password: 'password') }
  let(:valid_attributes) do
    { name: 'Vegetarian', description: 'No meat or animal products', restriction: true }
  end
  let(:invalid_attributes) do
    { name: nil, description: nil, restriction: true }
  end
  let(:new_attributes) do
    { name: 'Vegan', description: 'No animal products whatsoever', restriction: true }
  end

  before do
    sign_in user
  end

  describe 'PATCH /preferences/:id' do
    context 'with valid parameters' do
      let!(:preference) { Preference.create!(valid_attributes) }

      it 'updates the requested preference' do
        patch "/preferences/#{preference.id}", params: { preference: new_attributes }
        preference.reload

        expect(preference.name).to eq('Vegan')
        expect(preference.description).to eq('No animal products whatsoever')
        expect(preference.restriction).to eq(true)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the updated preference as json' do
        patch "/preferences/#{preference.id}", params: { preference: new_attributes }

        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Vegan')
        expect(json_response['description']).to eq('No animal products whatsoever')
        expect(json_response['restriction']).to eq(true)
      end

      it 'allows partial updates' do
        patch "/preferences/#{preference.id}", params: { preference: { name: 'Vegan' } }

        preference.reload
        expect(preference.name).to eq('Vegan')
        expect(preference.description).to eq('No meat or animal products')
        expect(preference.restriction).to eq(true)
      end
    end

    context 'with invalid parameters' do
      let!(:preference) { Preference.create!(valid_attributes) }

      it 'returns unprocessable_entity status' do
        patch "/preferences/#{preference.id}", params: { preference: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the validation errors as json' do
        patch "/preferences/#{preference.id}", params: { preference: invalid_attributes }

        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Name can't be blank")
        expect(json_response['errors']).to include("Description can't be blank")
      end
    end

    context 'when the preference does not exist' do
      it 'returns not_found status' do
        patch '/preferences/999', params: { preference: new_attributes }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Preference not found')
      end
    end
  end

  describe 'DELETE /preferences/:id' do
    context 'when the preference exists' do
      let!(:preference) { Preference.create!(valid_attributes) }

      it 'destroys the requested preference' do
        expect {
          delete "/preferences/#{preference.id}"
        }.to change(Preference, :count).by(-1)
      end

      it 'returns no_content status' do
        delete "/preferences/#{preference.id}"
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the preference does not exist' do
      it 'returns not_found status with error message' do
        delete '/preferences/999'
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Preference not found')
      end
    end
  end

  describe 'GET /preferences/:id' do
    let!(:preference) do
      Preference.create!(name: 'Sample Preference', description: 'This is a sample preference.', restriction: true)
    end

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
        expect(JSON.parse(response.body)['error']).to eq('Preference not found')
      end
    end
  end
end
