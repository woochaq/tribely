class Views::Projects::New < Views::App::Base
  include Phlex::Rails::Helpers::FormFor
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::TurboFrameTag

  def initialize(project:)
    @project = project
  end

  def page_title
    "New Project - Tribely"
  end

  def view_template
    header(class: "mb-8") do
      h1(class: "text-3xl font-bold text-text") { "Create a New Project" }
    end

    render Components::Projects::Form.new(project: @project)
  end
end
