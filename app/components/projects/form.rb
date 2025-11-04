class Components::Projects::Form < Components::AppLayout
  include Phlex::Rails::Helpers::FormFor
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::TurboFrameTag

  def initialize(project:, organizations: [])
    @project = project
    @organizations = organizations
  end


  def view_template
    turbo_frame_tag "projects-form" do
      div(class: "mx-auto bg-mantle p-8 rounded-2xl border border-crust shadow-lg shadow-crust/20") do
        simple_form_for(@project, html: { data: { turbo_frame: "_top" } }) do |f|
          div(class: "space-y-6") do
            unless @project.persisted?
              f.association :organization,
                            collection: @organizations,
                            label_method: :name,
                            value_method: :id,
                            prompt: "Choose an organization"
            end
            f.input :name, autofocus: true, input_html: { autocomplete: "off" }
            f.input :prefix, input_html: { autocomplete: "off", maxlength: 10 }, hint: "Used to identify tasks and actions within this project (e.g., TRB-123)"

            div(class: "flex items-center justify-end gap-4 pt-4") do
              a(href: projects_path, class: "btn-secondary", data: { turbo_frame: "_top" }) { "Cancel" }
              if @project.persisted?
                f.button :submit, "Update Project", class: "btn-primary"
              else
                f.button :submit, "Create Project", class: "btn-primary"
              end
            end
          end
        end
      end
    end
  end
end
