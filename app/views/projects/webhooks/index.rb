class Views::Projects::Webhooks::Index < Views::Projects::Base
  def initialize(project:, webhooks:, webhook:)
    @webhooks = webhooks
    @webhook = webhook
    super(project: project)
  end

  def view_template
    super do
      render Components::Projects::Webhooks::List.new(project: @project, webhooks: @webhooks, webhook: @webhook)
    end
  end
end
