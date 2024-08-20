require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'with valid credentials' do
      before do
        post :create, params: { user: { email: user.email, password: user.password } }
      end

      it 'redirects to the dashboards path after sign in' do
        expect(response).to redirect_to(dashboards_path)
      end
    end

    context 'with invalid credentials' do
      before do
        post :create, params: { user: { email: user.email, password: 'wrongpassword' } }
      end

      it 'does not sign in the user' do
        expect(controller.current_user).to be_nil
      end
    end
  end

  # describe 'DELETE #destroy' do
  #   before do
  #     sign_in user
  #     delete :destroy
  #   end

  #   it 'signs the user out' do
  #     expect(controller.current_user).to be_nil
  #   end

  #   it 'redirects to the root path without subdomain' do
  #     expect(response).to redirect_to(root_url(subdomain: false))
  #   end

  #   it 'sets a flash message for signed out' do
  #     expect(flash[:notice]).to eq(I18n.t('devise.sessions.signed_out'))
  #   end
  # end
end
