require 'rails_helper'

RSpec.describe "Projects::Webhooks", type: :request do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:board) { create(:board, project: project) }

  before do
    create(:organization_user, organization: organization, user: owner, role: :owner)
    create(:project_user, project: project, user: owner, role: :owner)

    create(:organization_user, organization: organization, user: member, role: :member)
    create(:project_user, project: project, user: member, role: :member)
  end

  describe "GET /projects/:project_id/webhooks" do
    context "as an owner" do
      before { sign_in owner }

      it "returns http success" do
        get project_webhooks_path(project)
        expect(response).to have_http_status(:success)
      end
    end

    context "as a member" do
      before { sign_in member }

      it "redirects to referrer or projects path" do
        get project_webhooks_path(project)
        expect(response).to redirect_to(projects_path)
        expect(flash[:alert]).to eq("You are not authorized to perform this action.")
      end
    end
  end

  describe "POST /projects/:project_id/webhooks" do
    before { sign_in owner }
    let(:valid_attributes) { { name: "GitHub", board_id: board.id, active: true, webhook_type: "create_story" } }
    let(:invalid_attributes) { { name: "", board_id: nil } }

    context "with valid parameters" do
      it "creates a new Webhook" do
        expect {
          post project_webhooks_path(project), params: { webhook: valid_attributes }
        }.to change(Webhook, :count).by(1)
      end

      it "redirects to the webhooks list" do
        post project_webhooks_path(project), params: { webhook: valid_attributes }
        expect(response).to redirect_to(project_webhooks_path(project))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Webhook" do
        expect {
          post project_webhooks_path(project), params: { webhook: invalid_attributes }
        }.to change(Webhook, :count).by(0)
      end

      it "returns unprocessable content status" do
        post project_webhooks_path(project), params: { webhook: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /projects/:project_id/webhooks/:id" do
    let!(:webhook) { create(:webhook, project: project, created_by: owner, board: board) }
    before { sign_in owner }

    context "with valid parameters" do
      it "updates the requested webhook" do
        patch project_webhook_path(project, webhook), params: { webhook: { name: "New Name" } }
        webhook.reload
        expect(webhook.name).to eq("New Name")
      end

      it "renders turbo stream" do
        patch project_webhook_path(project, webhook), params: { webhook: { name: "New Name" } }, as: :turbo_stream
        expect(response.media_type).to eq Mime[:turbo_stream]
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      it "does not update the webhook" do
        patch project_webhook_path(project, webhook), params: { webhook: { name: "" } }
        webhook.reload
        expect(webhook.name).not_to eq("")
      end

      it "returns unprocessable content status" do
        patch project_webhook_path(project, webhook), params: { webhook: { name: "" } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /projects/:project_id/webhooks/:id" do
    let!(:webhook) { create(:webhook, project: project, created_by: owner, board: board) }
    before { sign_in owner }

    it "destroys the requested webhook" do
      expect {
        delete project_webhook_path(project, webhook)
      }.to change(Webhook, :count).by(-1)
    end

    it "redirects to the webhooks list" do
      delete project_webhook_path(project, webhook)
      expect(response).to redirect_to(project_webhooks_path(project))
    end
  end
end
