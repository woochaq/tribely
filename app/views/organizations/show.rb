class Views::Organizations::Show < Views::Organizations::Base
  def view_template
    super do
      projects = policy_scope(@organization.projects)
      if projects.any?
        div(class: "bg-mantle rounded-lg border border-crust shadow-lg") do
          ul(class: "divide-y divide-crust") do
            projects.each do |project|
              render Components::Projects::ListItem.new(project: project, current_user: current_user)
            end
          end
        end
      else
        div(class: "bg-mantle p-8 rounded-2xl border border-crust shadow-lg shadow-crust/20 text-center") do
          h3(class: "text-xl font-semibold text-text") { "No projects yet!" }
          p(class: "text-subtext0 mt-2") { "This organization doesn't have any projects." }
          if policy(@organization).create?
            div(class: "mt-6") do
              a(href: new_project_path(project: { organization_id: @organization.id }), class: "btn-primary") { "Create First Project" }
            end
          end
        end
      end
    end
  end
end
