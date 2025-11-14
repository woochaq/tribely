require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /projects/:project_id/users/mentions" do
    let(:user) { create(:user) }
    let(:organization) { user.organizations.first }
    let(:project) { create(:project, organization: organization) }
    let!(:project_member) { create(:user, full_name: "John Doe", email: "john@example.com") }
    let!(:another_member) { create(:user, full_name: "Jane Smith", email: "jane@example.com") }
    let!(:non_member) { create(:user, full_name: "Adam John", email: "adam@another.com") }

    before do
      organization.users << project_member
      organization.users << another_member
      project.users << project_member
      project.users << another_member
      project.users << user
      sign_in user
    end

    context "when authenticated and a project member" do
      it "returns a successful response" do
        get project_users_mentions_path(project), params: { filter: "John" }
        expect(response).to have_http_status(:success)
      end

      it "returns users matching the filter" do
        get project_users_mentions_path(project), params: { filter: "John" }
        expect(response.body).to include("John Doe")
      end

      it "does not return users who do not match the filter" do
        get project_users_mentions_path(project), params: { filter: "John" }
        expect(response.body).not_to include("Jane Smith")
      end

      it "does not return users who are not members of the project" do
        get project_users_mentions_path(project), params: { filter: "Adam" }
        expect(response.body).not_to include("Adam John")
      end
    end

    context "when not authenticated" do
      it "redirects to the sign-in page" do
        sign_out user
        get project_users_mentions_path(project), params: { filter: "test" }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when not a project member" do
      it "raises a not found error" do
        other_project = create(:project)
        get project_users_mentions_path(other_project), params: { filter: "test" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
