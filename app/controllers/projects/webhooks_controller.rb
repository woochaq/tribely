class Projects::WebhooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_webhook, only: [ :edit, :update, :destroy ]

  def index
    @webhook = @project.webhooks.build
    authorize @webhook, :index?
    @webhooks = @project.webhooks.includes(:created_by, :board).order(created_at: :desc)
    render Views::Projects::Webhooks::Index.new(
      project: @project,
      webhooks: @webhooks,
      webhook: @webhook
    )
  end

  def create
    @webhook = @project.webhooks.build(webhook_params)
    @webhook.created_by = current_user
    authorize @webhook

    if @webhook.save
      redirect_to project_webhooks_path(@project), notice: "Webhook created successfully."
    else
      @webhooks = @project.webhooks.order(created_at: :desc)
      render Views::Projects::Webhooks::Index.new(
        project: @project,
        webhooks: @webhooks,
        webhook: @webhook
      ), status: :unprocessable_content
    end
  end

  def edit
    authorize @webhook
    render Components::Projects::Webhooks::Edit.new(project: @project, webhook: @webhook)
  end

  def update
    authorize @webhook
    if @webhook.update(webhook_params)
      render turbo_stream: turbo_stream.replace(@webhook, Components::Projects::Webhooks::ListItem.new(webhook: @webhook))
    else
      render Components::Projects::Webhooks::Edit.new(project: @project, webhook: @webhook), status: :unprocessable_content
    end
  end

  def destroy
    authorize @webhook
    @webhook.destroy

    respond_to do |format|
      format.html { redirect_to project_webhooks_path(@project), notice: "Webhook deleted successfully." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@webhook) }
    end
  end

  private

  def set_project
    @project = policy_scope(Project).find_by!(slug: params[:project_id])
  end

  def set_webhook
    @webhook = @project.webhooks.find(params[:id])
  end

  def webhook_params
    params.require(:webhook).permit(:name, :board_id, :active, :webhook_type)
  end
end
