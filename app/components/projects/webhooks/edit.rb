class Components::Projects::Webhooks::Edit < Components::Base
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::TurboFrameTag

  attr_reader :project, :webhook

  def initialize(project:, webhook:)
    @project = project
    @webhook = webhook
  end

  def view_template
    turbo_frame_tag dom_id(webhook) do
      div(class: "bg-mantle rounded-lg border border-crust shadow-lg p-6") do
        h2(class: "text-2xl font-bold tracking-tight text-text mb-4") { "Edit Webhook" }
        render Components::Projects::Webhooks::Form.new(project: project, webhook: webhook)
      end
    end
  end
end
