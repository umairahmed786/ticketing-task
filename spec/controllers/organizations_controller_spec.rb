require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  let(:valid_attributes) { attributes_for(:organization) }
  let(:invalid_attributes) { { name: '', subdomain: '' } }
  let!(:owner_role) { create(:role, :owner) }

  before do
    allow(controller).to receive(:build_url_with_subdomain).and_return('http://subdomain.localhost:3000/users/sign_up?role_id=1')
  end

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
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new organization' do
        expect do
          post :create, params: { organization: valid_attributes }
        end.to change(Organization, :count).by(1)
      end

      it 'redirects to the correct subdomain with role_id in query' do
        post :create, params: { organization: valid_attributes }
        expect(response).to redirect_to('http://subdomain.localhost:3000/users/sign_up?role_id=1')
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
  end

  # describe 'GET #render_login_form' do
  #   it 'renders the login form' do
  #     get :render_login_form
  #     expect(response).to render_template(:render_login_form)
  #   end
  # end

  # describe 'POST #login_existing' do
  #   context 'when the subdomain is blank' do
  #     it 're-renders the login form with an error' do
  #       post :login_existing, params: { subdomain: '' }
  #       expect(response).to render_template(:render_login_form)
  #       expect(flash.now[:error]).to eq(I18n.t('organization.subdomain_blank'))
  #     end
  #   end

  #   context 'when the subdomain is invalid' do
  #     it 're-renders the login form with an error' do
  #       post :login_existing, params: { subdomain: 'invalid_subdomain!' }
  #       expect(response).to render_template(:render_login_form)
  #       expect(flash.now[:error]).to eq(I18n.t('organization.subdomain_invalid'))
  #     end
  #   end

  #   context 'when the subdomain does not exist' do
  #     it 're-renders the login form with an error' do
  #       post :login_existing, params: { subdomain: 'nonexistent' }
  #       expect(response).to render_template(:render_login_form)
  #       expect(flash.now[:error]).to eq(I18n.t('organization.not_found'))
  #     end
  #   end

  #   context 'when the subdomain exists' do
  #     let!(:organization) { create(:organization, subdomain: 'existing') }

  #     it 'redirects to the login page with the correct subdomain' do
  #       post :login_existing, params: { subdomain: 'existing' }
  #       expect(response).to redirect_to('http://existing.localhost:3000/users/sign_in?role_id=1')
  #     end
  #   end
  # end
end