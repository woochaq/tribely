require 'rails_helper'

RSpec.describe HomePolicy, type: :policy do
  subject { described_class }

  let(:user) { create(:user) }
  let(:guest) { nil }

  permissions :index? do
    it "grants access to any user" do
      expect(subject).to permit(user)
    end

    it "grants access to any guest" do
      expect(subject).to permit(guest)
    end
  end
end
