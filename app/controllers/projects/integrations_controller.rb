class Projects::IntegrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_integration, only: [ :edit, :update, :destroy ]

  def index
    @integrations = policy_scope(@project.integrations).order(created_at: :desc)
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

  private

  def set_project
    @project = policy_scope(Project).find(params[:project_id])
  end

  def set_integration
    @integration = policy_scope(@project.integrations).find(params[:id])
  end

  def integration_params
    params.require(:integration).permit(:name, :type, :active, :webhook_url)
  end

  def build_integration_from_type(type)
    if Integration::TYPES.include?(type)
      type.constantize.new
    else
      Integration.new(type: type)
    end
  end
end
