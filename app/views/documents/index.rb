class Views::Documents::Index < Views::App::Base
  include Pundit::Authorization

  def initialize(documents:, current_project:)
    @documents = documents
    @current_project = current_project
  end

  def view_template
    div(class: "container mx-auto px-4 sm:px-6 lg:px-8 py-8") do
      div(class: "flex items-center justify-between gap-4 mb-6") do
        h1(class: "text-3xl font-bold text-text") { "Documents" }
        if policy(Document.new(project: @current_project)).create?
          a(href: new_project_document_path(@current_project), class: "btn-primary") { "New Document" }
        end
      end
      if @documents.present?
        div(class: "bg-mantle rounded-lg border border-crust shadow-lg") do
          ul(class: "divide-y divide-crust") do
            @documents.each do |document|
              render Components::Documents::ListItem.new(document: document, current_project: current_project)
            end
          end
        end
      else
        render_empty_state
      end
    end
  end

  private

  def render_empty_state
    div(class: "bg-mantle p-8 rounded-2xl border border-crust shadow-lg shadow-crust/20 text-center") do
      h3(class: "text-xl font-semibold text-text") { "No documents kyet!" }
      p(class: "text-subtext0 mt-2") { "It looks like you haven't created any documents." }

      div(class: "mt-6") do
        if policy(Document.new(project: @current_project)).create?
          a(href: new_project_document_path(@current_project), class: "btn-primary") { "Create Your First Document" }
        end
      end
    end
  end
end
