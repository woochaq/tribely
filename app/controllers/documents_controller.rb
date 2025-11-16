class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_document, only: %i[show update destroy edit]

  def index
    authorize Document
    @documents = policy_scope(@project.documents.includes(:created_by)).order(created_at: :desc)
    if params[:query].present?
      @documents = @documents.search(params[:query])
    end

    render Views::Documents::Index.new(documents: @documents, current_project: @project)
  end

  def show
    authorize @document
    render Views::Documents::Show.new(document: @document, current_project: @project)
  end

  def new
    @document = @project.documents.new
    authorize @document
    render Views::Documents::New.new(document: @document, current_project: @project)
  end

  def create
    @document = @project.documents.new(permitted_attributes(Document))
    @document.created_by = current_user
    @document.last_updated_by = current_user
    authorize @document

    if @document.save
      flash[:success] = "Document was successfully create."
      redirect_to project_document_path(@project, @document)
    else
      render Views::Documents::New.new(document: @document, current_project: @project), status: :unprocessable_content
    end
  end

  def edit
    authorize @document
    render Views::Documents::Edit.new(document: @document, current_project: @project)
  end

  def update
    authorize @document
    @document.last_updated_by = current_user
    if @document.update(permitted_attributes(@document))
      flash[:success] = "Document was successfully updated."
      redirect_to project_document_path(@project, @document)
    else
      render Views::Documents::Edit.new(document: @document, current_project: @project), status: :unprocessable_content
    end
  end

  def destroy
    authorize @document
    @document.destroy!
    flash[:success] = "Document was successfully deleted."
    redirect_to project_documents_path(@project)
  end

  def mentions
    authorize @project, :show?
    @documents = params[:filter].present? ? @project.documents.search(params[:filter]).limit(10) : []
    render Components::Documents::PromptItems.new(documents: @documents)
  end

  private

  def set_project
    @project = policy_scope(Project).find(params[:project_id])
  end

  def set_document
    @document = policy_scope(@project.documents).friendly.find(params[:id])
  end
end
