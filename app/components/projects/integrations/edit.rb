class Components::Projects::Integrations::Edit < Components::Base
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::TurboFrameTag

  attr_reader :project, :integration

  def initialize(project:, integration:)
    @project = project
    @integration = integration
  end

  def view_template
    turbo_frame_tag dom_id(integration) do
      div(class: "bg-mantle rounded-lg border border-crust shadow-lg p-6") do
        h2(class: "text-2xl font-bold tracking-tight text-text mb-4") { "Edit Integration" }
        render Components::Projects::Integrations::Form.new(project: project, integration: integration)
      end
    end
  end
end
