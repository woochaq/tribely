class Components::Projects::Webhooks::Form < Components::Base
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::DOMID
  include SimpleForm::ActionViewExtensions::FormHelper

  attr_reader :project, :webhook

  def initialize(project:, webhook:)
    @project = project
    @webhook = webhook
  end

  def view_template
    simple_form_for([ project, webhook ], namespace: dom_id(webhook), html: { class: "flex flex-col gap-4" }, data: { turbo_progress_bar: true }) do |f|
      div(class: "grid grid-cols-1 sm:grid-cols-2 gap-4") do
        f.input :name, wrapper_html: { class: "w-full" }, placeholder: "e.g. Github Integration"
        f.input :board_id, as: :select, collection: project.boards.map { |b| [ b.kind.humanize, b.id ] }, include_blank: false, label: "Target Board", wrapper_html: { class: "w-full" }
      end
      div(class: "grid grid-cols-1 sm:grid-cols-2 gap-4 items-start") do
        f.input :webhook_type, as: :select, collection: Webhook.webhook_types.keys.map { |t| [ t.humanize, t ] }, include_blank: false, label: "Type", wrapper_html: { class: "w-full" }

        div(class: "flex items-center h-full sm:pt-6") do
           render Components::Shared::Form::Switch.new(form: f, field: :active)
        end
      end

      div(class: "flex gap-2") do
        f.button :submit, webhook.persisted? ? "Update Webhook" : "Create Webhook", class: "btn-primary w-full sm:w-auto"
        if webhook.persisted?
           a(href: project_webhooks_path(project), class: "btn-secondary w-full sm:w-auto text-center") { "Cancel" }
        end
      end
    end
  end
end
