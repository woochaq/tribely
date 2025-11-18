require 'rails_helper'

RSpec.describe "Subscriptions", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/subscriptions/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    let(:valid_attributes) {
      { email_subscription: { email: "jon.doe@example.com" } }
    }
    it "redirect to new" do
      post subscriptions_path, params: valid_attributes
      expect(response).to redirect_to(new_subscription_path)
    end
  end
end
