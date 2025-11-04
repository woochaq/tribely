class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: [ :show, :edit, :update ]

  def index
    authorize Organization
    @organizations = policy_scope(Organization)
    render Views::Organizations::Index.new(organizations: @organizations)
  end

  def show
    render Views::Organizations::Show.new(organization: @organization)
  end

  def edit
    render Views::Organizations::Edit.new(organization: @organization)
  end

  def update
    if @organization.update(permitted_attributes(@organization))
      flash[:success] = "Organization '#{@organization.name}' updated."
      redirect_to organization_path, status: :see_other
    else
      render Views::Organizations::Edit.new(organization: @organization), status: :unprocessable_content
    end
  end

  private

  def set_organization
    @organization = policy_scope(Organization).find(params[:id])
    authorize @organization
  end
end
