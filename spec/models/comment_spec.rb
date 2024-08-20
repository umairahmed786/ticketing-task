require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:issue) { create(:issue, organization: organization) }


  
  before do
    create(:comment, organization: organization)
  end

  it { is_expected.to have_one(:issue_history) }
  it { is_expected.to have_many_attached(:files) }

  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to validate_length_of(:content).is_at_least(3) }
end