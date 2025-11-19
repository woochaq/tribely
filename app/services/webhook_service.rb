class WebhookService
  attr_reader :webhook, :payload

  def initialize(webhook, payload)
    @webhook = webhook
    @payload = payload.with_indifferent_access
  end

  def process
    case webhook.webhook_type
    when "create_story"
      create_story
    end
  end

  private

  def create_story
    # Basic implementation assumes payload contains story attributes

    story_params = payload.slice(:title, :description, :story_type)
    story_params[:board_id] = webhook.board_id
    story_params[:project_id] = webhook.project_id
    story_params[:owner_id] = webhook.created_by_id # Default to webhook creator as owner

    # Set defaults if missing
    story_params[:story_type] ||= "feature"
    story_params[:status] ||= "todo"

    Story.create!(story_params)
  end
end
