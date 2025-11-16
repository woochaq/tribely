require 'rails_helper'

RSpec.describe Document, type: :model do
  describe "associations" do
    it { should belong_to(:project) }
    it { should belong_to(:created_by).class_name('User').optional(true) }
    it { should belong_to(:last_updated_by).class_name('User').optional(true) }
    it { should have_rich_text(:content) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(255) }

    context "custom validations" do
      let(:organization) { create(:organization) }
      let(:project) { create(:project, organization: organization) }
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

      describe "#creator_must_be_valid_member" do
        it "is valid when created_by is an organization owner" do
          document = build(:document, project: project, created_by: org_owner)
          expect(document).to be_valid
        end

        it "is valid when created_by is a project member" do
          document = build(:document, project: project, created_by: project_member)
          expect(document).to be_valid
        end

        it "is invalid when created_by is a project guest" do
          document = build(:document, project: project, created_by: project_guest)
          expect(document).not_to be_valid
          expect(document.errors[:created_by]).to include("is not a valid member")
        end

        it "is invalid when created_by is not in the project or organization" do
          document = build(:document, project: project, created_by: outsider)
          expect(document).not_to be_valid
          expect(document.errors[:created_by]).to include("is not a valid member")
        end
      end

      describe "#last_updated_by_must_be_valid_member" do
        it "is valid when last_updated_by is an organization owner" do
          document = build(:document, project: project, last_updated_by: org_owner)
          expect(document).to be_valid
        end

        it "is valid when last_updated_by is a project member" do
          document = build(:document, project: project, last_updated_by: project_member)
          expect(document).to be_valid
        end

        it "is invalid when last_updated_by is a project guest" do
          document = build(:document, project: project, last_updated_by: project_guest)
          expect(document).not_to be_valid
          expect(document.errors[:last_updated_by]).to include("is not a valid member")
        end

        it "is invalid when last_updated_by is not in the project or organization" do
          document = build(:document, project: project, last_updated_by: outsider)
          expect(document).not_to be_valid
          expect(document.errors[:last_updated_by]).to include("is not a valid member")
        end
      end
    end
  end

  describe "FriendlyId" do
    let(:project) { create(:project, prefix: "TR") }
    let!(:document) { create(:document, project: project, title: "My Awesome Document") }

    it "generates a slug based on the title" do
      expect(document.slug).to eq("tr-my-awesome-document")
    end

    it "generates a unique slug scoped to the project" do
      document2 = create(:document, project: project, title: "My Awesome Document")
      expect(document2.slug).to start_with("tr-my-awesome-document-")
    end
  end

  describe "@content_type" do
    it "returns actiontext.document_mention for lexxy editor" do
      expect(described_class.new.content_type).to eq ("application/vnd.actiontext.document_mention")
    end
  end
end
