class Projects::IntegrationsController < ApplicationController
  rate_limit to: 4, within: 1.minute, only: :test, by: -> { current_user.id }

  before_action :authenticate_user!
  before_action :set_project
  before_action :set_integration, only: [ :edit, :update, :destroy, :test ]

  def index
    @integrations = policy_scope(@project.integrations).includes(:created_by).order(created_at: :desc)
    @integration = Integrations::Slack.new(project: @project) # Default to Slack for the new form
    authorize @integration, :index?

    render Views::Projects::Integrations::Index.new(
      project: @project,
      integrations: @integrations,
      integration: @integration
    )
  end

  def create
    @integration = build_integration_from_type(integration_params[:type])
    @integration.project = @project
    @integration.created_by = current_user
    authorize @integration

    if @integration.update(integration_params.except(:type))
      redirect_to project_integrations_path(@project), notice: "Integration created successfully."
    else
      @integrations = policy_scope(@project.integrations).order(created_at: :desc)
      render Views::Projects::Integrations::Index.new(
        project: @project,
        integrations: @integrations,
        integration: @integration
      ), status: :unprocessable_content
    end
  end

  def edit
    authorize @integration
    render Components::Projects::Integrations::Edit.new(
      project: @project,
      integration: @integration
    )
  end

  def update
    authorize @integration
    if @integration.update(integration_params)
      render turbo_stream: turbo_stream.replace(@integration, Components::Projects::Integrations::ListItem.new(integration: @integration))
    else
      render Components::Projects::Integrations::Edit.new(
        project: @project,
        integration: @integration
      ), status: :unprocessable_content
    end
  end

  def destroy
    authorize @integration
    @integration.destroy

    respond_to do |format|
      format.html { redirect_to project_integrations_path(@project), notice: "Integration deleted successfully." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@integration) }
    end
  end

  def test
    authorize @integration

    begin
      @integration.test_connection
      message = "Test message sent successfully!"
      type = :notice
    rescue => e
      message = "Failed to send test message: #{e.message}"
      type = :alert
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("flash-container", Components::Shared::Toast.new(type: type, message: message))
      end
    end
  end

  private

  def set_project
    @project = policy_scope(Project).find(params[:project_id])
  end

  def set_integration
    @integration = policy_scope(@project.integrations).find(params[:id])
  end

  def integration_params
    params.require(:integration).permit(:name, :type, :active, :webhook_url, events: [])
  end

  def build_integration_from_type(type)
    if Integration::TYPES.include?(type)
      type.constantize.new
    else
      Integration.new(type: type)
    end
  end
end
