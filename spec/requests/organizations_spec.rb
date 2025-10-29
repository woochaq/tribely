require 'rails_helper'

RSpec.describe "/organizations", type: :request do
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:other_user) { create(:user) }

  let(:shared_organization) { create(:organization) }

  before do
    create(:organization_user, user: owner, organization: shared_organization, role: :owner)
    create(:organization_user, user: member, organization: shared_organization, role: :member)
  end

  let(:valid_attributes) { { name: "Updated Org Name" } }
  let(:invalid_attributes) { { name: "" } }

  describe "GET /index" do
    context "when authenticated" do
      before { sign_in owner }
      it "succeeds" do
        get organizations_url
        expect(response).to be_successful
      end
    end

    context "when not authenticated" do
      it "redirects to the login page" do
        get organizations_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET /show" do
    context "when authenticated as an owner" do
      before { sign_in owner }
      it "succeeds" do
        get organization_url(shared_organization)
        expect(response).to be_successful
      end
    end

    context "when authenticated as a member" do
      before { sign_in member }
      it "succeeds" do
        get organization_url(shared_organization)
        expect(response).to be_successful
      end
    end

    context "when authenticated as an unrelated user" do
      before { sign_in other_user }
      it "is forbidden and raises RecordNotFound" do
        get organization_url(shared_organization)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "GET /edit" do
    context "when authenticated as an owner" do
      before { sign_in owner }
      it "succeeds for an organization they own" do
        get edit_organization_url(shared_organization)
        expect(response).to be_successful
      end
    end

    context "when authenticated as a member" do
      before { sign_in member }
      it "is forbidden and raises NotAuthorizedError" do
        expect { get edit_organization_url(shared_organization) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when authenticated as an unrelated user" do
      before { sign_in other_user }
      it "is forbidden and raises RecordNotFound" do
        get edit_organization_url(shared_organization)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "PATCH /update" do
    context "when authenticated as an owner" do
      before { sign_in owner }
      it "updates the organization and redirects" do
        patch organization_url(shared_organization), params: { organization: valid_attributes }
        shared_organization.reload
        expect(shared_organization.name).to eq("Updated Org Name")
        expect(response).to redirect_to(organizations_url)
      end
    end

    context "when authenticated as a member" do
      before { sign_in member }
      it "is forbidden and raises NotAuthorizedError" do
        expect { patch organization_url(shared_organization), params: { organization: valid_attributes } }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end

