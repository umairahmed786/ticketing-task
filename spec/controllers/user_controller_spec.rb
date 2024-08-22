require 'rails_helper'

RSpec.describe UserController, type: :controller do
  let(:organization) { create(:organization) }
  let(:owner) { ActsAsTenant.with_tenant(organization) { create(:user, role: create(:role, :owner)) } }

  before do
    allow_any_instance_of(ActionDispatch::Request).to receive(:subdomain).and_return(organization.subdomain.to_s)
    ActsAsTenant.current_tenant = organization
    sign_in owner
  end

  after do
    ActsAsTenant.current_tenant = nil
  end

  describe 'GET #index' do
    it 'displays users' do
      get :index
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    it 'assigns the requested user' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'GET #new' do
    it 'assigns a new user' do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'when the user already exists in the organization' do
      let(:user) { create(:user) }
      let(:user_params) { attributes_for(:user) }
      let!(:existing_user) { create(:user, email: user_params[:email]) }

      it 'does not create a new user and shows an error message' do
        expect {
          post :create, params: { user: user_params }
        }.not_to change(User, :count)
        expect(flash[:error]).to eq(I18n.t('user_exists'))
        expect(response).to render_template(:new)
      end
    end

    context 'when the user does not exist in the organization' do
      let(:role) { create(:role) }
      let(:valid_attributes) do
        attributes_for(:user).merge(organization_id: organization.id, role_id: role.id)
      end
      subject do
        user = User.new(valid_attributes)
        user.skip_confirmation!
        user.save!
        post :create, params: { user: valid_attributes }
      end
      it 'creates a new user and sends an invite email' do
        expect do
          subject
        end.to change(User, :count).by(1)

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #edit_user_profile' do
    let(:user) { create(:user) }
    it 'assigns the requested user' do
      get :edit_user_profile, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'PATCH #update_user_profile' do
    let(:user) { create(:user) }
    context 'with valid attributes' do
      it 'updates the user and sends a data updated email' do
        patch :update_user_profile, params: { id: user.id, user: { name: 'New Name' } }
        expect(assigns(:user).reload.name).to eq('New Name')
        expect(flash[:notice]).to eq(I18n.t('user_updated'))
        expect(response).to redirect_to user_index_path
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }
    it 'assigns the requested user' do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }
    context 'with valid attributes' do
      it 'updates the user' do
        patch :update, params: { id: user.id, user: { name: 'Updated Name' } }
        expect(assigns(:user).reload.name).to eq('Updated Name')
        expect(flash[:notice]).to eq(I18n.t('devise.registrations.updated'))
        expect(response).to redirect_to user_path(owner)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    it 'deletes the user and redirects to index' do
      delete :destroy, params: { id: user.id }
      expect(User.exists?(user.id)).to be_falsey
      expect(response).to redirect_to user_index_path
    end
  end
end
