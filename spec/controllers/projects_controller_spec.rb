require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:organization) { create(:organization) }
  let(:project_manager_role) { create(:role, :project_manager) }
  let(:general_user_role) { create(:role, :general_user) }
  let(:admin_role) { create(:role, :admin) }
  let(:user) { create(:user, organization: organization, role: project_manager_role) }
  let(:project_manager) { create(:user, organization: organization, role: project_manager_role) }
  let(:general_user) { create(:user, organization: organization, role: general_user_role) }
  let(:admin) { create(:user, organization: organization, role: admin_role) }
  let(:project) { create(:project, organization: organization, admin: admin, project_manager: project_manager) }

  before do
    allow_any_instance_of(ActionDispatch::Request).to receive(:subdomain).and_return(organization.subdomain.to_s)
    ActsAsTenant.current_tenant = organization
    sign_in user
  end

  after do
    ActsAsTenant.current_tenant = nil
  end

  describe 'GET #index' do
    context 'when user is a project manager' do
      before do
        user.update(role: project_manager_role)
        project.update(project_manager: user)
        get :index
      end

      it 'assigns @projects' do
        expect(assigns(:projects)).to eq([project])
      end
    end

    context 'when user is a general user' do
      before do
        user.update(role: general_user_role)
        project.users << user
        get :index
      end

      it 'assigns @projects' do
        expect(assigns(:projects)).to eq([project])
      end
    end

    context 'when user is an admin' do
      before do
        user.update(role: admin_role)
        get :index
      end

      it 'assigns @projects' do
        expect(assigns(:projects)).to eq([project])
      end
    end
  end

  describe 'GET #new' do
    before do
      user.update(role: admin_role)
      get :new
    end
    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    before do
      user.update(role: admin_role)
    end
    context 'with valid attributes' do
      it 'creates a new project' do
        expect {
          post :create, params: { project: attributes_for(:project) }
        }.to change(Project, :count).by(1)
      end

      it 'redirects to the new project' do
        post :create, params: { project: attributes_for(:project) }
        expect(response).to redirect_to(Project.last)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new project' do
        expect {
          post :create, params: { project: attributes_for(:project, title: nil) }
        }.not_to change(Project, :count)
      end

      it 're-renders the new template' do
        post :create, params: { project: attributes_for(:project, title: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #show' do
    before do
      user.update(role: admin_role)
      project.users << general_user
      get :show, params: { id: project.id }
    end

    it 'assigns @organization_general_users' do
      expect(assigns(:organization_general_users)).to be_present
    end

    it 'assigns @project_general_users' do
      expect(assigns(:project_general_users)).to be_present
    end

    it 'assigns @issues' do
      expect(assigns(:issues)).to eq(project.issues)
    end
  end

  describe 'GET #edit' do
    before do
      user.update(role: admin_role)
    end
    it 'renders the edit template' do
      get :edit, params: { id: project.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    before do
      user.update(role: admin_role)
    end
    context 'with valid attributes' do
      it 'updates the project' do
        patch :update, params: { id: project.id, project: { title: 'New Title' } }
        project.reload
        expect(project.title).to eq('New Title')
      end

      it 'redirects to the project' do
        patch :update, params: { id: project.id, project: { title: 'New Title' } }
        expect(response).to redirect_to(project)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the project' do
        patch :update, params: { id: project.id, project: { title: nil } }
        project.reload
        expect(project.title).not_to be_nil
      end

      it 're-renders the edit template' do
        patch :update, params: { id: project.id, project: { title: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      user.update(role: admin_role)
    end
    it 'deletes the project' do
      project
      expect {
        delete :destroy, params: { id: project.id }
      }.to change(Project, :count).by(-1)
    end

    it 'redirects to projects path' do
      delete :destroy, params: { id: project.id }
      expect(response).to redirect_to(projects_path)
    end
  end

  describe 'POST #add_user' do
    before do
      user.update(role: admin_role)
    end
    it 'adds users to the project' do
      user_to_add = create(:user)
      post :add_user, params: { id: project.id, to_be_added_users: [user_to_add.id] }
      expect(project.users).to include(user_to_add)
    end

    it 'redirects to the project' do
      post :add_user, params: { id: project.id, to_be_added_users: [user.id] }
      expect(response).to redirect_to(project)
    end
  end

  describe 'DELETE #remove_user' do
    before do
      user.update(role: admin_role)
      @new_user = create(:user)
    end
    it 'removes users from the project and redirects to the project' do
      project.users << @new_user
      delete :remove_user, params: { id: project.id, user_id: @new_user.id }
      expect(response).to redirect_to(project)
    end
  end
end
