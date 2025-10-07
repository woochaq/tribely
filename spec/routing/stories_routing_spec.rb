require "rails_helper"

RSpec.describe StoriesController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/projects/1/stories/new").to route_to("stories#new", project_id: "1")
    end

    it "routes to #show" do
      expect(get: "/projects/1/stories/1").to route_to("stories#show", project_id: "1", id: "1")
    end

    it "routes to #create" do
      expect(post: "/projects/1/stories").to route_to("stories#create", project_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/projects/1/stories/1").to route_to("stories#update", project_id: "1", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/projects/1/stories/1").to route_to("stories#update", project_id: "1", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/projects/1/stories/1").to route_to("stories#destroy", project_id: "1", id: "1")
    end
  end
end
