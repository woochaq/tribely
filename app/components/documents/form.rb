class Components::Documents::Form < Components::Base
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::DOMClass
  include SimpleForm::ActionViewExtensions::FormHelper

  def initialize(document:, current_project: nil)
    @document = document
    @current_project = current_project
  end

  def view_template
    h1(class: "text-3xl font-bold text-text mb-6") { @document.new_record? ? "New Document" : "Edit Document" }

    simple_form_for([ @current_project, @document ], class: "space-y-4") do |f|
      f.input :title, input_html: { placeholder: "Document title" }
      f.rich_text_area :content,  class: "prose max-w-none lexxy-content wysiwyg-editor min-h-[35vh] mt-6" do
        if @document.project.present?
          render Components::Shared::LexxyPrompts.new(project: @document.project)
        end
      end

      div(class: "flex items-center justify-end gap-4 pt-4") do
        if @document.persisted?
          link_to "Cancel", project_document_url(@current_project, @document), class: "btn-secondary", data: { turbo_frame: "_top" }
          f.button :submit, "Update Document", class: "btn-primary"
        else
          a(href: projects_path, class: "btn-secondary", data: { turbo_frame: "_top" }) { "Cancel" }
          f.button :submit, "Create Document", class: "btn-primary"
        end
      end
    end
  end
end
