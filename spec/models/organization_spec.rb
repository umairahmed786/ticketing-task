require 'rails_helper'

RSpec.describe Organization, type: :model do
  subject { build(:organization, attributes) }

  context "when valid" do
    let(:attributes) { {} }

    it { is_expected.to be_valid }
  end

  context "when invalid" do
    context "without a name" do
      let(:attributes) { { name: nil } }

      it { is_expected.to be_invalid }
      it { is_expected.to validate_presence_of(:name) }
    end

    context "without a subdomain" do
      let(:attributes) { { subdomain: nil } }

      it { is_expected.to be_invalid }
      it { is_expected.to validate_presence_of(:subdomain) }
    end

    context "with a duplicate name" do
      let(:attributes) { { subdomain: "another-example" } }

      before { create(:organization, name: "Example Organization") }

      it { is_expected.to be_invalid }
      it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    end

    context "with a duplicate subdomain" do
      let(:attributes) { { name: "Another Organization" } }

      before { create(:organization, subdomain: "example") }

      it { is_expected.to be_invalid }
      it { is_expected.to validate_uniqueness_of(:subdomain).case_insensitive }
    end

    context "with an invalid subdomain format" do
      let(:attributes) { { subdomain: "example!" } }

      it { is_expected.to be_invalid }
      it 'validates subdomain format' do
        subject.valid?
        expect(subject.errors[:subdomain]).to include('must only contain alphabets and numbers, and must include at least one alphabet.')
      end
    end
  end
end