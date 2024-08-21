require 'rails_helper'

RSpec.describe Issue, type: :model do
  let(:organization) { create(:organization) }

  before do
    create(:issue, organization: organization)
  end

  it { is_expected.to belong_to(:project).class_name('Project') }
  it { is_expected.to belong_to(:assignee).class_name('User').optional }
  it { is_expected.to belong_to(:organization).class_name('Organization') }
  it { is_expected.to have_many(:issue_histories).class_name('IssueHistory').dependent(:destroy) }
  it { is_expected.to have_many(:comments).through(:issue_histories).dependent(:destroy) }
  it { is_expected.to have_many_attached(:files) }


  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_least(3) }
  it { is_expected.to validate_uniqueness_of(:title).scoped_to(:organization_id).case_insensitive }

  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_length_of(:description).is_at_least(10) }

  it { is_expected.to validate_inclusion_of(:complexity_point).in_range(0..5).with_message("must be between 0 and 5")}

end