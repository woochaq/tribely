require "rails_helper"

describe "Devise::SessionsController", type: :request do
  describe "POST /users/sign_in" do
    let(:user) { create(:user, password: "password") }
    let(:valid_credentials) { { email: user.email, password: "password" } }
    let(:invalid_credentials) { { email: user.email, password: "wrongpassword" } }

    context "with valid credentials" do
      it "signs the user in" do
        post user_session_path, params: { user: valid_credentials }
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(app_path)
        expect(session["warden.user.user.key"]).to eq([ [ user.id ], user.authenticatable_salt ])
      end

      it "returns a message that user is already signed in" do
        sign_in(user)
        post user_session_path, params: { user: valid_credentials }
        expect(response).to redirect_to(app_path)
      end
    end

    context "with invalid credentials" do
      it "does not sign the user in" do
        post user_session_path, params: { user: invalid_credentials }
        expect(response).to have_http_status(:unprocessable_content)
        expect(session["warden.user.user.key"]).to be_nil
      end
    end
  end
end
