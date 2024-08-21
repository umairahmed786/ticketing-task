require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  let(:valid_attributes) { attributes_for(:organization) }
  let(:invalid_attributes) { { name: '', subdomain: '' } }
  let!(:owner_role) { create(:role, :owner) }
  let!(:organization) { create(:organization, valid_attributes) }

  

  describe 'GET #index' do
    context 'when user is signed in' do
      before do
        sign_in create(:user)
        get :index
      end

      it 'redirects to dashboards path' do
        expect(response).to redirect_to(dashboards_path)
      end
    end

    context 'when user is not signed in' do
      it 'does not redirect to dashboards path' do
        get :index
        expect(response).not_to redirect_to(dashboards_path)
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new organization to @organization' do
      get :new
      expect(assigns(:organization)).to be_a_new(Organization)
    end

    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new organization and redirects to the expected path' do
        request.host = "#{valid_attributes[:subdomain]}.host.com"
        post :create, params: { organization: valid_attributes }

        organization = Organization.last
        expect(organization.name).to eq(valid_attributes[:name])
        expect(organization.subdomain).to eq(valid_attributes[:subdomain])
        expect(response).to be_successful
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new organization' do
        expect do
          post :create, params: { organization: invalid_attributes }
        end.not_to change(Organization, :count)
      end

      it "re-renders the 'new' template" do
        post :create, params: { organization: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'sets an error flash message' do
        post :create, params: { organization: invalid_attributes }
        expect(flash.now[:error]).to be_present
      end
    end

    context 'when subdomain contains spaces' do
      let(:invalid_attributes) { { name: 'Test Org', subdomain: 'invalid subdomain' } }

      it 'does not create a new organization' do
        expect do
          post :create, params: { organization: invalid_attributes }
        end.not_to change(Organization, :count)
      end

      it "re-renders the 'new' template" do
        post :create, params: { organization: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'sets an error flash message' do
        post :create, params: { organization: invalid_attributes }
        expect(flash.now[:error]).to be_present
      end
    end

    context 'when subdomain contains special characters' do
      let(:invalid_attributes) { { name: 'Test Org', subdomain: 'invalid!subdomain' } }

      it 'does not create a new organization' do
        expect do
          post :create, params: { organization: invalid_attributes }
        end.not_to change(Organization, :count)
      end

      it "re-renders the 'new' template" do
        post :create, params: { organization: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'sets an error flash message' do
        post :create, params: { organization: invalid_attributes }
        expect(flash.now[:error]).to be_present
      end
    end

    context 'when subdomain contains only numbers' do
      let(:invalid_attributes) { { name: 'Test Org', subdomain: '123456' } }

      it 'does not create a new organization' do
        expect do
          post :create, params: { organization: invalid_attributes }
        end.not_to change(Organization, :count)
      end

      it "re-renders the 'new' template" do
        post :create, params: { organization: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'sets an error flash message' do
        post :create, params: { organization: invalid_attributes }
        expect(flash.now[:error]).to be_present
      end
    end
  end

  describe 'GET #render_login_form' do
    it 'renders the login form' do
      get :render_login_form
      expect(response).to render_template(:render_login_form)
    end
  end

  describe 'POST #login_existing' do
    context 'when the subdomain is blank' do
      it 're-renders the login form with an error' do
        post :login_existing, params: { subdomain: '' }
        expect(response).to render_template(:render_login_form)
        expect(flash.now[:error]).to eq(I18n.t('organization.subdomain_blank'))
      end
    end

    context 'when the subdomain is invalid' do
      it 're-renders the login form with an error' do
        post :login_existing, params: { subdomain: 'invalid_subdomain!' }
        expect(response).to render_template(:render_login_form)
        expect(flash.now[:error]).to eq(I18n.t('organization.subdomain_invalid'))
      end
    end

    context 'when the subdomain does not exist' do
      it 're-renders the login form with an error' do
        post :login_existing, params: { subdomain: 'nonexistent' }
        expect(response).to render_template(:render_login_form)
        expect(flash.now[:error]).to eq(I18n.t('organization.not_found'))
      end
    end

    context 'when the subdomain exists' do
      let!(:organization) { create(:organization, subdomain: 'existing') }

      it 'redirects to the login page with the correct subdomain' do
        post :login_existing, params: { subdomain: 'existing' }

        expected_url = "http://existing.test.example.com:3000/en/users/sign_in?role_id=#{owner_role.id}"
        expect(response).to redirect_to(expected_url)
      end
    end
  end
end
