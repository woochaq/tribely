class Views::Documents::Edit < Views::Documents::Base
  def initialize(document:, current_project:)
    @document = document
    @current_project = current_project
    super(document: @document, current_project: @current_project)
  end

  def view_template
    super do
      render Components::Documents::Form.new(document: @document, current_project: @current_project)
    end
  end

  def page_title
    "#{@current_project.name} / Documents / #{@document.title} / Edit"
  end
end
