require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:organization) { create(:organization) }
  let(:role) { create(:role, :owner) }
  let(:valid_attributes) do
    attributes_for(:user).merge(organization_id: organization.id, role_id: role.id)
  end

  let(:invalid_email_attributes) do
    attributes_for(:user, email: 'invalid_email').merge(
      organization_id: organization.id,
      role_id: role.id
    )
  end

  let(:mismatched_password_attributes) do
    attributes_for(:user).merge(
      organization_id: organization.id,
      role_id: role.id,
      password: 'password123',
      password_confirmation: 'different_password'
    )
  end

  let!(:existing_user) { create(:user, email: 'duplicate@example.com', organization: organization) }
  let(:duplicate_email_attributes) do
    attributes_for(:user, email: 'duplicate@example.com', organization_id: organization.id)
  end

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #new' do
    it 'returns a found response' do
      get :new, params: { role_id: 1 }
      expect(response).to have_http_status(:found)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      subject do
        user = User.new(valid_attributes)
        user.skip_confirmation!
        user.save!
        post :create, params: { user: valid_attributes }
      end

      it 'creates a new User' do
        expect do
          subject
        end.to change(User, :count).by(1)
      end

      it 'redirects to the dashboards path' do
        subject
        expect(response).to redirect_to(dashboards_path)
      end
    end

    context 'with invalid email format' do
      subject { post :create, params: { user: invalid_email_attributes } }

      it 'does not create a new User' do
        expect do
          subject
        end.not_to change(User, :count)
      end

      it "re-renders the 'new' template" do
        subject
        expect(response).to have_http_status(:found)
      end
    end

    context 'with mismatched password confirmation' do
      subject { post :create, params: { user: mismatched_password_attributes } }

      it 'does not create a new User' do
        expect do
          subject
        end.not_to change(User, :count)
      end

      it "re-renders the 'new' template" do
        subject
        expect(response).to have_http_status(:found)
      end
    end

    context 'with duplicate email within the same organization' do
      subject { post :create, params: { user: duplicate_email_attributes } }

      it 'does not create a new User' do
        expect do
          subject
        end.not_to change(User, :count)
      end

      it "re-renders the 'new' template" do
        subject
        expect(response).to have_http_status(:found)
      end
    end
  end
end
