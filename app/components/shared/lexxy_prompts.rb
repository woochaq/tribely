class Components::Shared::LexxyPrompts < Components::Base
  register_element def lexxy_prompt(**attributes, &content) = nil

  def initialize(project: project)
    @project = project
  end

  def view_template
    lexxy_prompt(
      trigger: "^",
      src: mentions_project_documents_path(@project),
      name: "mention",
      "remote-filtering": true,
      "supports-space-in-searches": true
    )
    lexxy_prompt(
      trigger: "#",
      src: mentions_project_stories_path(@project),
      name: "mention",
      "remote-filtering": true,
      "supports-space-in-searches": true
    )
    lexxy_prompt(
      trigger: "@",
      src: project_users_mentions_path(@project),
      name: "mention",
      "remote-filtering": true,
      "supports-space-in-searches": true
    )
  end
end
