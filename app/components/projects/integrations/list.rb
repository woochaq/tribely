class Components::Projects::Integrations::List < Components::Base
  include Pundit::Authorization

  attr_reader :project, :integrations, :integration

  def initialize(project:, integrations:, integration:)
    @project = project
    @integrations = integrations
    @integration = integration
  end

  def view_template
    div do
      if policy(integration).create?
        render_create_integration_form
      end

      div(class: "mt-8") do
        h2(class: "text-2xl font-bold tracking-tight text-text mb-4") { "Integrations" }
        div(class: "bg-mantle rounded-lg border border-crust shadow-lg") do
          ul(class: "divide-y divide-crust") do
            if integrations.any?
              integrations.each do |integration|
                render Components::Projects::Integrations::ListItem.new(integration: integration)
              end
            else
              li(class: "p-4 text-subtext0") { "No integrations found." }
            end
          end
        end
      end
    end
  end

  private

  def render_create_integration_form
    div(class: "bg-mantle rounded-lg border border-crust shadow-lg p-6") do
      h2(class: "text-2xl font-bold tracking-tight text-text mb-4") { "Create a new integration" }
      render Components::Projects::Integrations::Form.new(project: project, integration: integration)
    end
  end
end
