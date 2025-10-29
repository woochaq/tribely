class Views::Organizations::Show < Views::App::Base
  def initialize(organization:)
    @organization = organization
  end

  def view_template
    div(class: "container mx-auto px-4 py-8") do
      div(class: "mb-8") do
        h1(class: "text-3xl font-bold text-text") { @organization.name }
        p(class: "text-subtext0 mt-1") { "Details and members of the organization." }
      end

      render Components::Organizations::UserList.new(organization: @organization)
    end
  end
end
