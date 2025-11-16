class Views::Documents::Base < Views::App::Base
  include Pundit::Authorization
  include Phlex::Rails::Helpers::LinkTo

  def initialize(document:, current_project:, **)
    super(current_project: current_project, **)
    @current_project = current_project
    @document = document
  end

  def view_template(&block)
    div(class: "container mx-auto px-4 sm:px-6 lg:px-8 py-8") do
      # Header
      div(class: "flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8") do
        div(class: "flex items-center gap-x-3 min-w-0") do
          h1(class: "text-1xl  md:text-3xl font-bold text-text flex items-center  min-w-0 truncate") do
            a(href: project_documents_path(@current_project), class: "text-primary") { "Documents" }
            span(class: "mx-2 text-subtext0") { "/" }
            span { @document.title }
          end
        end
      end
      div(class: "mx-auto bg-mantle p-8 rounded-2xl border border-crust shadow-lg text-text") do
        div(&block)
      end
    end
  end
end
