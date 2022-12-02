# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'POST /create' do
    subject(:send_request) { post :create, params: params }

    context 'when all the params are valid' do
      context 'when all the necessary params exist' do
        let(:params) do
          { user:
            { email: 'first_user@mail.ru', name: 'First User', password: '12345678',
              password_confirmation: '12345678' } }
        end

        it 'creates new user' do
          expect { send_request }.to change(User, :count).by(1)
        end
      end

      context 'when not all the necessary params exist' do
        let(:params) do
          { user: { email: 'first_user@mail.ru', name: 'First User', password: '12345678' } }
        end

        it 'does not create new user' do
          expect { send_request }.not_to change(User, :count)
        end

        it 'returns the error' do
          send_request

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when not all params are valid' do
      let(:params) do
        { user: { email: 'first_user@mail.ru', name: 'First User', password: '123', password_confirmation: '123' } }
      end

      it 'does not create new user' do
        expect { send_request }.not_to change(User, :count)
      end

      it 'returns the error' do
        send_request

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
