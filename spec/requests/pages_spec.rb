require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /privacy" do
    it "returns http success" do
      get privacy_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Privacy Policy")
    end
  end

  describe "GET /terms" do
    it "returns http success" do
      get terms_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Terms of Service")
    end
  end
end
