require "rails_helper"

RSpec.describe CommentsController, type: :routing do
  describe "routing" do
    let(:project) { create(:project) }
    let(:board) { create(:board, project: project) }
    let(:story) { create(:story, board: board) }

    it "routes to #new" do
      expect(get: "/projects/#{project.id}/stories/#{story.id}/comments/new").to route_to("comments#new", project_id: project.id.to_s, story_id: story.id.to_s)
    end

    it "routes to #show" do
      expect(get: "/projects/#{project.id}/stories/#{story.id}/comments/1").to route_to("comments#show", project_id: project.id.to_s, story_id: story.id.to_s, id: "1")
    end

    it "routes to #edit" do
      expect(get: "/projects/#{project.id}/stories/#{story.id}/comments/1/edit").to route_to("comments#edit", project_id: project.id.to_s, story_id: story.id.to_s, id: "1")
    end

    it "routes to #create" do
      expect(post: "/projects/#{project.id}/stories/#{story.id}/comments").to route_to("comments#create", project_id: project.id.to_s, story_id: story.id.to_s)
    end

    it "routes to #update via PUT" do
      expect(put: "/projects/#{project.id}/stories/#{story.id}/comments/1").to route_to("comments#update", project_id: project.id.to_s, story_id: story.id.to_s, id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/projects/#{project.id}/stories/#{story.id}/comments/1").to route_to("comments#update", project_id: project.id.to_s, story_id: story.id.to_s, id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/projects/#{project.id}/stories/#{story.id}/comments/1").to route_to("comments#destroy", project_id: project.id.to_s, story_id: story.id.to_s, id: "1")
    end
  end
end
