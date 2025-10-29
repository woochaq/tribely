class Views::Organizations::Index < Views::App::Base
  def initialize(organizations:)
    @organizations = organizations
  end

  def view_template
    div(class: "container mx-auto px-4 py-8") do
      h1(class: "text-3xl font-bold mb-6") { "My Organizations" }

      div(class: "bg-mantle rounded-lg border border-crust shadow-lg hover:bg-surface0") do
        ul(class: "divide-y divide-crust") do
          @organizations.each do |organization|
            render Components::Organizations::ListItem.new(
              organization: organization,
              current_user: view_context.current_user
            )
          end
        end
      end
    end
  end
end
