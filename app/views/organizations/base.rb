class Views::Organizations::Base < Views::App::Base
  include Pundit::Authorization
  include Phlex::Rails::Helpers::CurrentPage
  include Phlex::Rails::Helpers::ImageTag

  def initialize(organization:, **)
    @organization = organization
    super(**)
  end

  def view_template(&block)
    div(class: "container mx-auto px-4 sm:px-6 lg:px-8 py-8") do
      # Header
      div(class: "flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8") do
        div(class: "flex items-center gap-x-3 min-w-0") do
          h1(class: "text-1xl  md:text-3xl font-bold text-text flex items-center  min-w-0 truncate") do
            a(href: organizations_path, class: "text-primary") { "Organizations" }
            span(class: "mx-2 text-subtext0") { "/" }
            if current_page?(edit_organization_path(@organization))
              if @organization.avatar.attached?
                image_tag @organization.avatar.variant(:thumb), class: "w-8 h-8 rounded-lg flex-shrink-0 mr-2"
              end
              a(href: organization_path(@organization), class: "text-primary hover:underline") { @organization.name }
              span(class: "mx-2 text-subtext0") { "/" }
              span { "Edit" }
            else
              if @organization.avatar.attached?
                image_tag @organization.avatar.variant(:thumb), class: "w-8 h-8 rounded-lg flex-shrink-0 mr-2"
              end
              span { @organization.name }
            end
          end
          if policy(@organization).edit?
            a(href: edit_organization_path(@organization), class: "text-subtext0 hover:text-text") do
              render Icons::Edit.new(class: "w-6 h-6")
            end
          end
        end
      end

      # Tabs
      div(class: "mb-4") do
        if !current_page?(edit_organization_path(@organization))
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
                href: organization_members_path(@organization),
                class: "#{base_mobile_classes} rounded-r-lg #{current_page?(organization_members_path(@organization)) ? active_mobile_classes : inactive_mobile_classes}"
              ) { "Members" }
            end
            # Mobile Action Button
            div(class: "mt-4 flex justify-end") do
              if current_page?(organization_path(@organization)) && policy(Project.new(organization: @organization)).create?
                a(href: new_project_path(organization_id: @organization.id), class: "btn-primary") { "New Project" }
              end
              # Placeholder for future "Add Member" button
              # if current_page?(organization_members_path(@organization)) && policy(...).create?
              #   a(href: new_member_path, class: "btn-primary w-full text-center") { "Add Member" }
              # end
            end
          end

          # Desktop - Tabs and Action Button
          div(class: "hidden sm:flex sm:items-center sm:justify-between") do
            nav(class: "flex space-x-2", aria_label: "Tabs") do
              base_classes = "font-bold rounded-md px-4 py-2 text-sm"
              active_classes = "bg-mantle text-primary"
              inactive_classes = "text-subtext0 hover:bg-mantle hover:text-text"

              a(
                href: organization_path(@organization),
                class: "#{base_classes} #{current_page?(organization_path(@organization)) ? active_classes : inactive_classes}"
              ) { "Projects" }
              a(
                href: organization_members_path(@organization),
                class: "#{base_classes} #{current_page?(organization_members_path(@organization)) ? active_classes : inactive_classes}"
              ) { "Members" }
            end

            # Desktop Action Button
            div do
              if current_page?(organization_path(@organization)) && policy(Project.new(organization: @organization)).create?
                a(href: new_project_path(project: { organization_id: @organization.id }), class: "btn-primary") { "New Project" }
              end
              # Placeholder for future "Add Member" button
              # if current_page?(organization_members_path(@organization)) && policy(...).create?
              #   a(href: new_member_path, class: "btn-primary") { "Add Member" }
              # end
            end
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
