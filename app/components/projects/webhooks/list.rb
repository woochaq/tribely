class Components::Projects::Webhooks::List < Components::Base
  include Pundit::Authorization

  attr_reader :project, :webhooks, :webhook

  def initialize(project:, webhooks:, webhook:)
    @project = project
    @webhooks = webhooks
    @webhook = webhook
  end

  def view_template
    div do
      if policy(webhook).create?
        render_create_webhook_form
      end

      div(class: "mt-8") do
        h2(class: "text-2xl font-bold tracking-tight text-text mb-4") { "Webhooks" }
        div(class: "bg-mantle rounded-lg border border-crust shadow-lg") do
          ul(class: "divide-y divide-crust") do
            if webhooks.any?
              webhooks.each do |webhook|
                render Components::Projects::Webhooks::ListItem.new(webhook: webhook)
              end
            else
              li(class: "p-4 text-subtext0") { "No webhooks found." }
            end
          end
        end
      end
    end
  end

  private

  def render_create_webhook_form
    div(class: "bg-mantle rounded-lg border border-crust shadow-lg p-6") do
      h2(class: "text-2xl font-bold tracking-tight text-text mb-4") { "Create a new webhook" }
      render Components::Projects::Webhooks::Form.new(project: project, webhook: webhook)
    end
  end
end
