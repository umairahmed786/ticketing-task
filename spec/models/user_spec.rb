require 'rails_helper'

RSpec.describe User, type: :model do
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }

  before do
    create(:user, organization: organization, role: role)
  end

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).scoped_to(:organization_id).case_insensitive }
  it { is_expected.to allow_value('user@example.com').for(:email) }
  it { is_expected.not_to allow_value('invalid_email').for(:email) }

  it { is_expected.to validate_presence_of(:password).on(:create) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(128) }
  it { is_expected.to validate_presence_of(:password_confirmation) }
end
