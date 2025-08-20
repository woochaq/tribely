require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let(:user) { FactoryBot.create(:user) }

  before :each do
    sign_in(user)
  end

  describe "GET /index" do
    it "returns http success" do
      get projects_path
      expect(response).to have_http_status(:success)
    end
  end
end
