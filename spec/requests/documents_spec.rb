require 'rails_helper'

RSpec.describe "Documents", type: :request do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:document) { create(:document, project: project) }

  let(:org_owner) { create(:user) }
  let(:project_member) { create(:user) }
  let(:project_guest) { create(:user) }
  let(:outsider) { create(:user) }

  before do
    create(:organization_user, organization: organization, user: org_owner, role: :owner)
    create(:organization_user, organization: organization, user: project_member, role: :member)
    create(:organization_user, organization: organization, user: project_guest, role: :guest)
    create(:project_user, project: project, user: project_member, role: :member)
    create(:project_user, project: project, user: project_guest, role: :guest)
  end

  describe "GET /projects/:project_id/documents" do
    context "as an organization owner" do
      it "returns a successful response" do
        sign_in org_owner
        get project_documents_path(project)
        expect(response).to be_successful
      end
    end

    context "as a project member" do
      it "returns a successful response" do
        sign_in project_member
        get project_documents_path(project)
        expect(response).to be_successful
      end
    end

    context "as a project guest" do
      it "returns a successful response" do
        sign_in project_guest
        get project_documents_path(project)
        expect(response).to be_successful
      end
    end

    context "as an outsider" do
      it "returns a not found response" do
        sign_in outsider
        get project_documents_path(project)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /projects/:project_id/documents/:id" do
    context "as an organization owner" do
      it "returns a successful response" do
        sign_in org_owner
        get project_document_path(project, document)
        expect(response).to be_successful
      end
    end

    context "as a project member" do
      it "returns a successful response" do
        sign_in project_member
        get project_document_path(project, document)
        expect(response).to be_successful
      end
    end

    context "as a project guest" do
      it "returns a successful response" do
        sign_in project_guest
        get project_document_path(project, document)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "as an outsider" do
      it "returns a not found response" do
        sign_in outsider
        get project_document_path(project, document)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /projects/:project_id/documents/new" do
    context "as an organization owner" do
      it "returns a successful response" do
        sign_in org_owner
        get new_project_document_path(project)
        expect(response).to be_successful
      end
    end

    context "as a project member" do
      it "returns a successful response" do
        sign_in project_member
        get new_project_document_path(project)
        expect(response).to be_successful
      end
    end

    context "as a project guest" do
      it "redirects to the root path" do
        sign_in project_guest
        get new_project_document_path(project)
        expect(response).to redirect_to(projects_path)
      end
    end

    context "as an outsider" do
      it "returns a not found response" do
        sign_in outsider
        get new_project_document_path(project)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /projects/:project_id/documents" do
    let(:valid_attributes) { { title: "New Document", content: "Some content" } }

    context "as an organization owner" do
      before { sign_in org_owner }

      it "creates a new document" do
        expect {
          post project_documents_path(project), params: { document: valid_attributes }
        }.to change(Document, :count).by(1)
      end
    end

    context "as a project member" do
      before { sign_in project_member }

      it "creates a new document" do
        expect {
          post project_documents_path(project), params: { document: valid_attributes }
        }.to change(Document, :count).by(1)
      end
    end

    context "as a project guest" do
      before { sign_in project_guest }

      it "does not create a new document" do
        expect {
          post project_documents_path(project), params: { document: valid_attributes }
        }.to_not change(Document, :count)
      end
    end

    context "as an outsider" do
      before { sign_in outsider }

      it "does not create a new document" do
        expect {
          post project_documents_path(project), params: { document: valid_attributes }
        }.to_not change(Document, :count)
      end
    end
  end

  describe "GET /projects/:project_id/documents/:id/edit" do
    context "as an organization owner" do
      it "returns a successful response" do
        sign_in org_owner
        get edit_project_document_path(project, document)
        expect(response).to be_successful
      end
    end

    context "as a project member" do
      it "returns a successful response" do
        sign_in project_member
        get edit_project_document_path(project, document)
        expect(response).to be_successful
      end
    end

    context "as a project guest" do
      it "redirects to the root path" do
        sign_in project_guest
        get edit_project_document_path(project, document)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "as an outsider" do
      it "returns a not found response" do
        sign_in outsider
        get edit_project_document_path(project, document)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH /projects/:project_id/documents/:id" do
    let(:new_attributes) { { title: "Updated Document" } }

    context "as an organization owner" do
      before { sign_in org_owner }

      it "updates the document" do
        patch project_document_path(project, document), params: { document: new_attributes }
        document.reload
        expect(document.title).to eq("Updated Document")
      end
    end

    context "as a project member" do
      before { sign_in project_member }

      it "updates the document" do
        patch project_document_path(project, document), params: { document: new_attributes }
        document.reload
        expect(document.title).to eq("Updated Document")
      end
    end

    context "as a project guest" do
      before { sign_in project_guest }

      it "does not update the document" do
        patch project_document_path(project, document), params: { document: new_attributes }
        document.reload
        expect(document.title).to_not eq("Updated Document")
      end
    end

    context "as an outsider" do
      before { sign_in outsider }

      it "does not update the document" do
        patch project_document_path(project, document), params: { document: new_attributes }
        document.reload
        expect(document.title).to_not eq("Updated Document")
      end
    end
  end

  describe "DELETE /projects/:project_id/documents/:id" do
    let!(:document_to_delete) { create(:document, project: project) }

    context "as an organization owner" do
      before { sign_in org_owner }

      it "destroys the document" do
        expect {
          delete project_document_path(project, document_to_delete)
        }.to change(Document, :count).by(-1)
      end
    end

    context "as a project member" do
      before { sign_in project_member }

      it "destroys the document" do
        expect {
          delete project_document_path(project, document_to_delete)
        }.to change(Document, :count).by(-1)
      end
    end

    context "as a project guest" do
      before { sign_in project_guest }

      it "does not destroy the document" do
        expect {
          delete project_document_path(project, document_to_delete)
        }.to_not change(Document, :count)
      end
    end

    context "as an outsider" do
      before { sign_in outsider }

      it "does not destroy the document" do
        expect {
          delete project_document_path(project, document_to_delete)
        }.to_not change(Document, :count)
      end
    end
  end
end
