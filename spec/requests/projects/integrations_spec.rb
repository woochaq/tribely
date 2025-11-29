require 'rails_helper'

RSpec.describe "Projects::Integrations", type: :request do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:owner_org) { create(:user) }
  let(:member_org) { create(:user) }

  before do
    create(:organization_user, organization: organization, user: owner_org, role: :owner)
    create(:organization_user, organization: organization, user: member_org, role: :member)
    create(:project_user, project: project, user: member_org, role: :member)
  end

  describe "GET /projects/:project_id/integrations" do
    context "when logged in as an organization owner" do
      before { sign_in owner_org }

      it "renders a successful response" do
        get project_integrations_path(project)
        expect(response).to be_successful
      end
    end

    context "when logged in as an organization member" do
      before { sign_in member_org }

      it "renders a successful response" do
        get project_integrations_path(project)

        expect(response).to redirect_to(projects_path)
        expect(flash[:alert]).to eq("You are not authorized to perform this action.")
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        get project_integrations_path(project)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /projects/:project_id/integrations" do
    let(:valid_attributes) { { type: 'Integrations::Slack', name: 'My Slack Integration', webhook_url: 'https://hooks.slack.com/services/T000/B000/XXX', active: true, events: [ 'story_created' ] } }
    let(:invalid_attributes) { { type: 'Integrations::Slack', name: '', webhook_url: '', active: true, events: [] } }

    context "when logged in as an organization owner" do
      before { sign_in owner_org }

      it "creates a new Integration" do
        expect {
          post project_integrations_path(project), params: { integration: valid_attributes }
        }.to change(Integration, :count).by(1)
      end

      it "redirects to the integrations list" do
        post project_integrations_path(project), params: { integration: valid_attributes }
        expect(response).to redirect_to(project_integrations_path(project))
        expect(flash[:notice]).to eq("Integration created successfully.")
      end

      it "does not create a new Integration with invalid attributes" do
        expect {
          post project_integrations_path(project), params: { integration: invalid_attributes }
        }.to change(Integration, :count).by(0)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when logged in as an organization member" do
      before { sign_in member_org }

      it "does not create an Integration and redirects to projects path" do
        post project_integrations_path(project), params: { integration: valid_attributes }
        expect(response).to redirect_to(projects_path)
      end
    end
  end

  describe "GET /projects/:project_id/integrations/:id/edit" do
    let!(:integration) { create(:slack_integration, project: project, created_by: owner_org) }

    context "when logged in as an organization owner" do
      before { sign_in owner_org }

      it "renders a successful response" do
        get edit_project_integration_path(project, integration)
        expect(response).to be_successful
      end
    end

    context "when logged in as an organization member" do
      before { sign_in member_org }

      it "redirects to projects path" do
        get edit_project_integration_path(project, integration)
        expect(response).to redirect_to(projects_path)
      end
    end
  end

  describe "PATCH /projects/:project_id/integrations/:id" do
    let!(:integration) { create(:slack_integration, project: project, created_by: owner_org) }
    let(:new_attributes) { { name: "Updated Slack Name", webhook_url: 'https://hooks.slack.com/services/NEW/WEBHOOK/URL', active: false, events: [ 'story_assigned', 'comment_created' ] } }

    context "when logged in as an organization owner" do
      before { sign_in owner_org }

      it "updates the requested integration" do
        patch project_integration_path(project, integration), params: { integration: new_attributes }
        integration.reload
        expect(integration.name).to eq("Updated Slack Name")
        expect(integration.webhook_url).to eq('https://hooks.slack.com/services/NEW/WEBHOOK/URL')
        expect(integration.active).to be_falsey
        expect(integration.events).to match_array([ 'story_assigned', 'comment_created' ])
      end

      it "renders a turbo stream response" do
        patch project_integration_path(project, integration), params: { integration: new_attributes }, as: :turbo_stream
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("<turbo-stream action=\"replace\" target=\"integration_#{integration.id}\">")
      end

      it "does not update the integration with invalid attributes" do
        patch project_integration_path(project, integration), params: { integration: { name: "" } }
        integration.reload
        expect(integration.name).not_to eq("")
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when logged in as an organization member" do
      before { sign_in member_org }

      it "does not update the integration and redirects to projects path" do
        patch project_integration_path(project, integration), params: new_attributes
        integration.reload
        expect(integration.name).not_to eq("Updated Slack Name")
        expect(response).to redirect_to(projects_path)
      end
    end
  end

  describe "DELETE /projects/:project_id/integrations/:id" do
    let!(:integration) { create(:slack_integration, project: project, created_by: owner_org) }

    context "when logged in as an organization owner" do
      before { sign_in owner_org }

      it "destroys the requested integration" do
        expect {
          delete project_integration_path(project, integration)
        }.to change(Integration, :count).by(-1)
      end

      it "redirects to the integrations list" do
        delete project_integration_path(project, integration)
        expect(response).to redirect_to(project_integrations_path(project))
        expect(flash[:notice]).to eq("Integration deleted successfully.")
      end

      it "renders a turbo stream response" do
        delete project_integration_path(project, integration), as: :turbo_stream
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("<turbo-stream action=\"remove\" target=\"integration_#{integration.id}\">")
      end
    end

    context "when logged in as an organization member" do
      before { sign_in member_org }

      it "does not destroy the integration and redirects to projects path" do
        expect {
          delete project_integration_path(project, integration)
        }.not_to change(Integration, :count)
        expect(response).to redirect_to(projects_path)
      end
    end
  end
end
