require 'rails_helper'

RSpec.describe "Docs", type: :request do
  describe "GET /docs" do
    context "when user is not logged in" do
      it "renders the docs page successfully with demo data" do
        get docs_path

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Tribely Guide")
        expect(response.body).to include("Acme Corp") # Demo data
        expect(response.body).to include("Demo Data")
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      let(:organization) { create(:organization, name: "Real Organization") }

      before do
        create(:organization_user, user: user, organization: organization, role: :owner)
        sign_in user
      end

      it "renders the docs page successfully with user data" do
        get docs_path

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Tribely Guide")
        expect(response.body).to include("Real Organization")
        expect(response.body).not_to include("Acme Corp")
        expect(response.body).not_to include("Demo Data")
      end
    end
  end
end
