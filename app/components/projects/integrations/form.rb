class Components::Projects::Integrations::Form < Components::Base
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::DOMID
  include SimpleForm::ActionViewExtensions::FormHelper

  attr_reader :project, :integration

  def initialize(project:, integration:)
    @project = project
    @integration = integration
  end

  def view_template
    simple_form_for([ project, integration ], namespace: dom_id(integration), html: { class: "flex flex-col gap-4" }, data: { turbo_progress_bar: true }) do |f|
      div(class: "grid grid-cols-1 sm:grid-cols-2 gap-4") do
        f.input :name, wrapper_html: { class: "w-full" }
        f.input :type, as: :select, collection: Integration.available_types, include_blank: false, label: "Type", wrapper_html: { class: "w-full" }
      end

      if integration.is_a?(Integrations::Slack)
        f.input :webhook_url, label: "Slack Webhook URL", hint: "e.g., https://hooks.slack.com/services/T000/B000/XXX", input_html: { value: integration.webhook_url }, wrapper_html: { class: "w-full" }
      elsif integration.is_a?(Integrations::Discord)
        f.input :webhook_url, label: "Discord Webhook URL", hint: "e.g., https://discord.com/api/webhooks/123456/abcdef", input_html: { value: integration.webhook_url }, wrapper_html: { class: "w-full" }
      end

      div(class: "space-y-2") do
        label(class: "text-sm font-medium text-text") { "Trigger Events" }
        div(class: "grid grid-cols-1 sm:grid-cols-2 gap-2") do
          f.collection_check_boxes :events, Integration.available_events, :last, :first do |b|
            div(class: "flex items-center gap-2") do
              b.check_box(class: "rounded border-surface0 bg-mantle text-primary focus:ring-primary")
              b.label(class: "text-sm text-text")
            end
          end
        end
      end

      div(class: "flex items-center h-full sm:pt-2") do
         render Components::Shared::Form::Switch.new(form: f, field: :active)
      end

      div(class: "flex gap-2") do
        f.button :submit, integration.persisted? ? "Update Integration" : "Create Integration", class: "btn-primary w-full sm:w-auto"
        if integration.persisted?
          a(href: project_integrations_path(project), class: "btn-secondary w-full sm:w-auto text-center") { "Cancel" }
        end
      end
    end
  end
end
