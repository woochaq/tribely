require "rails_helper"

describe "Users::ConfirmationsController", type: :request do
  describe "GET /user/confirmation/new" do
    it "renders the confirmation form" do
      get new_user_confirmation_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /user/confirmation" do
    let(:user) { create(:user, confirmed_at: nil, confirmation_token: "xxx") }

    it "redirect to sign in page" do
      user.update_attribute(:confirmation_token, "xxx")
      get user_confirmation_path, params: { confirmation_token: "xxx" }
      expect(response).to redirect_to(new_user_session_path)
      expect(user.reload.confirmed?).to be true
    end

    it "renders the confirmation form" do
      get user_confirmation_path, params: { confirmation_token: "wrong_token" }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "POST /user/confirmation" do
    let(:user) { create(:user, confirmed_at: nil) }

    context "with valid parameters" do
      it "confirms the user's email" do
        post user_confirmation_path, params: { user: { email: user.email } }
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(user_session_path)
        expect(user.reload.confirmation_token).to be_present
      end
    end

    context "with invalid parameters" do
      it "does not confirm the user's email" do
        post user_confirmation_path, params: { user: { email: "invalid@example.com" } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
