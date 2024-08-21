require 'rails_helper'

RSpec.describe IssuesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:project_manager_role) { create(:role, :project_manager) }
  let(:general_user_role) { create(:role, :general_user) }
  let(:admin_role) { create(:role, :admin) }
  let(:user) { create(:user, organization: organization, role: project_manager_role) }
  let(:project_manager) { create(:user, organization: organization, role: project_manager_role) }
  let(:general_user) { create(:user, organization: organization, role: general_user_role) }
  let(:admin) { create(:user, organization: organization, role: admin_role) }
  let(:project) { create(:project, organization: organization, admin: admin, project_manager: project_manager) }
  let(:issue) { create(:issue, project: project) }

  before do
    allow_any_instance_of(ActionDispatch::Request).to receive(:subdomain).and_return(organization.subdomain.to_s)
    ActsAsTenant.current_tenant = organization
    sign_in project_manager
  end

  after do
    ActsAsTenant.current_tenant = nil
  end

  describe 'GET #index' do
    it 'assigns @issues' do
      get :index, params: { project_id: project.id }
      expect(assigns(:issues)).to eq([issue])
    end
  end

  describe 'GET #new' do
    it 'assigns @available_states' do
      get :new, params: { project_id: project.id }
      expect(assigns(:available_states)).to be_present
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new issue' do
        expect {
          post :create, params: { project_id: project.id, issue: attributes_for(:issue) }
        }.to change(Issue, :count).by(1)
      end

      it 'redirects to the project issues path' do
        post :create, params: { project_id: project.id, issue: attributes_for(:issue) }
        expect(response).to redirect_to(project_issues_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new issue' do
        expect {
          post :create, params: { project_id: project.id, issue: attributes_for(:issue, title: nil) }
        }.to_not change(Issue, :count)
      end

      it 're-renders the new template' do
        post :create, params: { project_id: project.id, issue: attributes_for(:issue, title: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #show' do
    it 'shows issue detailed page' do
      get :show, params: { project_id: project.id, id: issue.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit' do
    it 'assigns @issue' do
      get :edit, params: { project_id: project.id, id: issue.id }
      expect(assigns(:issue)).to eq(issue)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the issue' do
        patch :update, params: { project_id: project.id, id: issue.id, issue: attributes_for(:issue, title: 'Updated Title') }
        issue.reload
        expect(issue.title).to eq('Updated Title')
      end

      it 'redirects to the project issue path' do
        patch :update, params: { project_id: project.id, id: issue.id, issue: attributes_for(:issue, title: 'Updated Title') }
        expect(response).to redirect_to(project_issue_path(project, issue))
      end
    end

    context 'with invalid attributes' do
      it 'does not update the issue' do
        patch :update, params: { project_id: project.id, id: issue.id, issue: attributes_for(:issue, title: nil) }
        issue.reload
        expect(issue.title).to_not be_nil
      end

      it 're-renders the edit template' do
        patch :update, params: { project_id: project.id, id: issue.id, issue: attributes_for(:issue, title: nil) }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the issue' do
      issue
      expect {
        delete :destroy, params: { project_id: project.id, id: issue.id }
      }.to change(Issue, :count).by(-1)
    end

    it 'redirects to project issues path' do
      delete :destroy, params: { project_id: project.id, id: issue.id }
      expect(response).to redirect_to(project_issues_path)
    end
  end

  describe 'POST #attach_file' do
    it 'attaches files to the issue' do
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_file.txt'), 'text/plain')
      expect {
        post :attach_file, params: { project_id: project.id, id: issue.id, files: [file] }
      }.to change(ActiveStorage::Attachment, :count).by(1)
    end

    it 'creates issue history records for the attached files' do
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_file.txt'), 'text/plain')
      expect {
        post :attach_file, params: { project_id: project.id, id: issue.id, files: [file] }
      }.to change(IssueHistory, :count).by(1)
    end

    it 'redirects to the project issue path' do
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_file.txt'), 'text/plain')
      post :attach_file, params: { project_id: project.id, id: issue.id, files: [file] }
      expect(response).to redirect_to(project_issue_path(project, issue))
    end
  end
end
