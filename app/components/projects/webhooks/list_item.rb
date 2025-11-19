class Components::Projects::Webhooks::ListItem < Components::Base
  include Pundit::Authorization
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::TimeAgoInWords

  attr_reader :webhook

  def initialize(webhook:)
    @webhook = webhook
  end

    def view_template
      turbo_frame_tag dom_id(webhook) do
        li(class: "p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-4 hover:bg-surface0 transition-colors duration-200") do
          div(class: "flex-grow min-w-0") do
            div(class: "flex items-center gap-2 mb-1") do
              span(class: "font-semibold text-text truncate") { webhook.name }
              status_badge
              type_badge
            end

                    div(class: "text-sm text-subtext0 font-mono bg-crust p-2 rounded border border-surface0 break-all select-all") do
                      api_webhook_url(webhook.token)
                    end
            div(class: "text-xs text-subtext0 mt-2") do
              span { "Created by #{webhook.created_by.name} • " }
              if webhook.last_triggered_at
                span { "Last triggered #{time_ago_in_words(webhook.last_triggered_at)} ago" }
              else
                 span { "Never triggered" }
              end
               span { " • Target: #{webhook.board.kind.humanize} Board" }
            end
          end

          div(class: "flex items-center gap-2 flex-shrink-0") do
            if policy(webhook).update?
              a(href: edit_project_webhook_path(webhook.project, webhook), class: "p-2") do
                render Icons::Edit.new(class: "w-5 h-5")
              end
            end

            if policy(webhook).destroy?
              button_to(project_webhook_path(webhook.project, webhook), method: :delete, class: "p-2", form: { data: { turbo_confirm: "Are you sure you want to delete this webhook?" } }) do
                render Icons::Delete.new(class: "w-5 h-5")
              end
            end
          end
        end
      end
    end
  private

  def status_badge
    if webhook.active?
      span(class: "inline-flex items-center rounded-md bg-primary/10 px-2 py-1 text-xs font-medium text-primary ring-1 ring-inset ring-primary/20") { "Active" }
    else
      span(class: "inline-flex items-center rounded-md bg-danger/10 px-2 py-1 text-xs font-medium text-danger ring-1 ring-inset ring-danger/20") { "Inactive" }
    end
  end

  def type_badge
    span(class: "inline-flex items-center rounded-md bg-accent/10 px-2 py-1 text-xs font-medium text-accent ring-1 ring-inset ring-accent/20") { webhook.webhook_type.humanize }
  end
end
