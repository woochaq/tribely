require "rails_helper"

describe "Devise::PasswordsController", type: :request do
  describe "GET /user/passwords/new" do
    it "renders the password reset form" do
      get new_user_password_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /user/passwords" do
    let(:user) { create(:user) }

    context "with exiting user" do
      it "sends a password reset email" do
        post user_password_path, params: { user: { email: user.email } }
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with not existing user" do
      it "does not send a password reset email" do
        post user_password_path, params: { user: { email: "invalid@example.com" } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /user/passwords/edit" do
    let(:user) { create(:user) }

    it "renders the password edit form" do
      token = user.send_reset_password_instructions

      get edit_user_password_path, params: { reset_password_token: token }
      expect(response).to have_http_status(:ok)
    end

    it "renders the password edit for invalid token" do
      get edit_user_password_path, params: { reset_password_token: "invalid_token" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PUT /user/passwords" do
    let(:user) { create(:user) }
    let(:valid_params) do
      {
        user: {
          reset_password_token: user.send_reset_password_instructions,
          password: "newpassword",
          password_confirmation: "newpassword"
        }
      }
    end

    context "with valid params" do
      it "updates the user's password" do
        put user_password_path, params: valid_params
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(app_path)
      end
    end

    context "with invalid params" do
      it "does not update the user's password" do
        put user_password_path, params: valid_params.merge(user: { password: "short", password_confirmation: "short" })
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
