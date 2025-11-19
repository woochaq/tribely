class Views::Documents::Show < Views::Documents::Base
  def initialize(document:, current_project:)
    @document = document
    super(document: @document, current_project: current_project)
  end

  def view_template
    super do
      div(class: "flex items-center justify-between mb-6") do
        h1(class: "text-3xl font-bold") { @document.title }
        div(class: "flex items-center space-x-4") do
          if policy(@document).edit?
            a(href: edit_project_document_path(@current_project, @document), class: "text-subtext0 hover:text-text") do
              render Icons::Edit.new(class: "w-6 h-6")
            end
          end
          if policy(@document).destroy?
            link_to(project_document_path(@current_project, @document), data: { turbo_method: :delete, turbo_confirm: "Are you sure you want to delete this document?" }) do
              render Icons::Delete.new(class: "w-5 h-5")
            end
          end
        end
      end

      div(class: "lexxy-content prose max-w-none", data: { controller: "syntax-highlight" }) do
        safe(@document.content.to_s)
      end

      if @document.content.embeds.attachments.present?
        div(class: "border-t border-crust") do
          div(class: "px-10 pt-5") do
            render Components::Shared::AttachmentCarousel.new(attachments: @document.content.embeds.attachments)
          end
        end
      end

      div(class: "pt-5 mt-8 text-sm text-subtext0 border-t border-crust") do
        p(class: "flex") do
          render PhlexIcons::Bootstrap::CalendarDay.new(class: "mr-1.5 size-4")
          span { "Created by #{(@document.created_by&.name|| "N/A")} on #{@document.created_at.to_formatted_s(:long)}" }
        end
        if @document.last_updated_by.present?
          p(class: "flex") do
            render PhlexIcons::Bootstrap::CalendarDay.new(class: "mr-1.5 size-4")
            span { "Last updated by #{@document.last_updated_by.name} on #{@document.updated_at.to_formatted_s(:long)}" }
          end
        end
      end
    end
  end
end
