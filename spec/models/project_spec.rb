require 'rails_helper'

RSpec.describe Project, type: :model do

  let(:organization) { create(:organization) }
  let(:admin) { create(:user, organization: organization) }
  let(:project_manager) { create(:user, organization: organization) }

  before do
    create(:project, title: 'Unique Title', organization: organization, admin: admin)
  end
  it { is_expected.to belong_to(:project_manager).class_name('User').optional }
  it { is_expected.to belong_to(:admin).class_name('User') }
  it { is_expected.to have_many(:project_users).dependent(:destroy) }
  it { is_expected.to have_many(:users).through(:project_users) }
  it { is_expected.to have_many(:issues).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_least(3) }
  
  it { is_expected.to validate_uniqueness_of(:title).scoped_to(:organization_id).case_insensitive }

  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_length_of(:description).is_at_least(10) }

  it { is_expected.to validate_presence_of(:admin) }

  describe '#search_data' do
    subject(:project) do
      create(:project, 
             title: 'Project Title', 
             description: 'Project Description',
             project_manager: project_manager, 
             admin: admin)
    end

    it 'returns a hash with the project attributes for search' do
      expected_data = {
        title: 'Project Title',
        description: 'Project Description',
        project_manager: project_manager.name
      }

      expect(project.search_data).to eq(expected_data)
    end
  end
end
