class Views::Organizations::Edit < Views::App::Base
  def initialize(organization:)
    @organization = organization
  end

  def view_template
    div(class: "container mx-auto px-4 py-8") do
      h1(class: "text-3xl font-bold mb-6") do
        span { "Edit Organization: " }
        span(class: "text-accent") { @organization.name }
      end

      render Components::Organizations::Form.new(organization: @organization)
    end
  end
end
