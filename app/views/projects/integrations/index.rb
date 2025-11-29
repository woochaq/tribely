class Views::Projects::Integrations::Index < Views::Projects::Base
  def initialize(project:, integrations:, integration:)
    @integrations = integrations
    @integration = integration
    super(project: project)
  end

  def view_template
    super do
      render Components::Projects::Integrations::List.new(
        project: @project,
        integrations: @integrations,
        integration: @integration
      )
    end
  end
end
