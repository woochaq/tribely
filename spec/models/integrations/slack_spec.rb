require 'rails_helper'

RSpec.describe Integrations::Slack, type: :model do
  describe 'validations' do
    # store_accessor specific validations might not work directly with shoulda-matchers depending on version/setup, 
    # but let's try or manual test.
    
    it "validates presence of webhook_url" do
      integration = build(:slack_integration, settings: { webhook_url: nil })
      expect(integration).not_to be_valid
      expect(integration.errors[:webhook_url]).to include("can't be blank")
    end

    it "validates format of webhook_url" do
      integration = build(:slack_integration, settings: { webhook_url: "invalid" })
      expect(integration).not_to be_valid
      expect(integration.errors[:webhook_url]).to include("must be a valid URL")
    end
  end
end
