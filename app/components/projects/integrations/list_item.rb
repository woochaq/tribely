class Components::Projects::Integrations::ListItem < Components::Base
  include Pundit::Authorization
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::TurboFrameTag

  attr_reader :integration

  def initialize(integration:)
    @integration = integration
  end

  def view_template
    turbo_frame_tag dom_id(integration) do
      li(class: "p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-4 hover:bg-surface0 transition-colors duration-200") do
        div(class: "flex-grow min-w-0") do
          div(class: "flex items-center gap-2 mb-1") do
            span(class: "font-semibold text-text truncate") { integration.name }
            status_badge
            type_badge
          end
          div(class: "text-xs text-subtext0 mt-2") do
            span { "Created by #{integration.created_by.name} • " }
            span { "Type: #{integration.type.demodulize}" }
          end
        end

        div(class: "flex items-center gap-2 flex-shrink-0") do
          if policy(integration).test?
            button_to(test_project_integration_path(integration.project, integration), method: :post, class: "hover:text-primary cursor-pointer p-2", title: "Send Test Message", data: { turbo_frame: "_top" }) do
              render PhlexIcons::Bootstrap::Send.new(class: "w-5 h-5")
            end
          end

          if policy(integration).update?
            a(href: edit_project_integration_path(integration.project, integration), class: "p-2") do
              render Icons::Edit.new(class: "w-5 h-5")
            end
          end

          if policy(integration).destroy?
            button_to(project_integration_path(integration.project, integration), method: :delete, class: "p-2", form: { data: { turbo_confirm: "Are you sure you want to delete this integration?" } }) do
              render Icons::Delete.new(class: "w-5 h-5")
            end
          end
        end
      end
    end
  end

  private

  def status_badge
    if integration.active?
      span(class: "inline-flex items-center rounded-md bg-primary/10 px-2 py-1 text-xs font-medium text-primary ring-1 ring-inset ring-primary/20") { "Active" }
    else
      span(class: "inline-flex items-center rounded-md bg-danger/10 px-2 py-1 text-xs font-medium text-danger ring-1 ring-inset ring-danger/20") { "Inactive" }
    end
  end

  def type_badge
    span(class: "inline-flex items-center rounded-md bg-accent/10 px-2 py-1 text-xs font-medium text-accent ring-1 ring-inset ring-accent/20") { integration.type.demodulize }
  end
end
