class Components::Documents::Mention < Components::Base
  def initialize(document:)
    @document = document
  end

  def view_template
    a(href: project_document_path(@document.project, @document),  target: :_blank) do
      em(class: "text-primary font-semibold") { "^" + @document.title }
    end
  end
end
