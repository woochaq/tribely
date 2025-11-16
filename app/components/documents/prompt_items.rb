class Components::Documents::PromptItems < Components::Base
  def initialize(documents:)
    @documents = documents
  end

  def view_template
    @documents.each do |document|
      render Components::Documents::PromptItem.new(document: document)
    end
  end
end
