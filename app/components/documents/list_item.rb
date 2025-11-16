class Components::Documents::ListItem < Components::Base
  include Phlex::Rails::Helpers::LinkTo

  def initialize(document:, current_project:)
    @document = document
    @current_project = current_project
  end

  def view_template
    li() do
      link_to project_document_path(@current_project, @document), class: "block hover:bg-surface0 px-4 py-4 sm:px-6" do
        div(class: "flex items-center justify-between") do
          p(class: "font-semibold text-text truncate") { @document.title }
          div(class: "ml-2 flex-shrink-0 flex") do
            render_role_badge
          end
        end
        div(class: "mt-2 sm:flex sm:justify-between") do
          div(class: "sm:flex") do
            p(class: "flex items-center text-sm text-subtext0") do
              render Components::Icons::Calendar.new(class: "mr-1.5 h-5 w-5")
              span { "Created by #{(@document.created_by&.name|| "N/A")} on #{@document.created_at.to_formatted_s(:long)}" }
            end
          end
        end
      end
    end
  end

  def vi2ew_template
    li(class: "p-4 flex items-center justify-between hover:bg-surface0") do
      link_to(organization_path(@organization), class: "flex-grow flex items-center gap-x-4 min-w-0") do
        div(class: "w-10 h-10 bg-surface1 rounded-lg flex-shrink-0 flex itemx-center justify-center") do
          image_tag @organization.avatar.variant(:thumb) if @organization.avatar.attached?
        end

        div(class: "truncate") do
          span(class: "font-semibold text-text") { @organization.name }
        end
      end

      div(class: "flex items-center gap-x-4 flex-shrink-0") do
        render_role_badge
        if policy(@organization).edit?
          link_to edit_organization_path(@organization) do
            render Components::Icons::Edit.new(class: "w-5 h-5")
          end
        end
      end
    end
  end

  def render_role_badge
    span(class: "px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-accent text-crust") do
      @document.created_by&.name || "N/A"
    end
  end
end
