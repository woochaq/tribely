class Views::Organizations::Base < Views::App::Base
  include Pundit::Authorization
  include Phlex::Rails::Helpers::CurrentPage

  def initialize(organization:, **)
    @organization = organization
    super(**)
  end

  def view_template(&block)
    div(class: "container mx-auto px-4 sm:px-6 lg:px-8 py-8") do
      # Header
      div(class: "flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8") do
        div(class: "flex items-center gap-x-3") do
          h1(class: "text-3xl font-bold text-text") do
            a(href: organizations_path, class: "text-primary") { "My Organizations" }
            span(class: "mx-2 text-subtext0") { "/" }
            span { @organization.name }
          end
          if policy(@organization).edit?
            a(href: edit_organization_path(@organization), class: "text-subtext0 hover:text-text") do
              render Icons::Edit.new(class: "w-6 h-6")
            end
          end
        end
      end

      # Tabs
      div(class: "mb-8") do
        # Mobile - Segmented Control
        div(class: "sm:hidden") do
          nav(class: "isolate flex divide-x divide-surface0 rounded-lg shadow-sm", aria_label: "Tabs") do
            base_mobile_classes = "group relative min-w-0 flex-1 overflow-hidden bg-mantle py-3 px-4 text-center text-sm font-semibold hover:bg-surface2 focus:z-10"
            active_mobile_classes = "text-primary"
            inactive_mobile_classes = "text-text"

            a(
              href: organization_path(@organization),
              class: "#{base_mobile_classes} rounded-l-lg #{current_page?(organization_path(@organization)) ? active_mobile_classes : inactive_mobile_classes}"
            ) { "Projects" }
            a(
              href: members_organization_path(@organization),
              class: "#{base_mobile_classes} rounded-r-lg #{current_page?(members_organization_path(@organization)) ? active_mobile_classes : inactive_mobile_classes}"
            ) { "Members" }
          end
        end

        # Desktop - Tabs
        div(class: "hidden sm:block") do
          nav(class: "flex space-x-2", aria_label: "Tabs") do
            base_classes = "font-bold rounded-md px-4 py-2 text-sm"
            active_classes = "bg-mantle text-primary"
            inactive_classes = "text-subtext0 hover:bg-mantle hover:text-text"

            a(
              href: organization_path(@organization),
              class: "#{base_classes} #{current_page?(organization_path(@organization)) ? active_classes : inactive_classes}"
            ) { "Projects" }
            a(
              href: members_organization_path(@organization),
              class: "#{base_classes} #{current_page?(members_organization_path(@organization)) ? active_classes : inactive_classes}"
            ) { "Members" }
          end
        end
      end

      # Content
      div(&block)
    end
  end

  def page_title
    "My Organizations / #{@organization.name}"
  end
end
