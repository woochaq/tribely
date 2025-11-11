class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_story, only: %i[show update destroy autosave]
  before_action :set_story_for_move, only: [ :move ]

  def show
    authorize @story
    if turbo_frame_request?
      render Components::Stories::Form.new(story: @story, current_project: @project)
    else
      render Views::Projects::Show.new(project: @project, current_project: @project, story_to_show: @story)
    end
  end

  def new
    @story = Story.new(owner: current_user, board: Board.find(params[:board_id]))
    authorize @story
    render Components::Stories::Form.new(story: @story, current_project: @project)
  end

  def create
    @story = @project.stories.new(permitted_attributes(Story))
    @story.owner = current_user
    authorize @story

    if @story.save
      respond_with_streams(message: "Story was successfully created.")
    else
      render_form_with_errors
    end
  end

  def update
    authorize @story
    if @story.update(permitted_attributes(@story))
      if params[:state_change]
        render Components::Stories::Form.new(story: @story, current_project: @project), status: :ok
      else
        respond_with_streams(message: "Story was successfully updated.")
      end
    else
      render_form_with_errors
    end
  end

  def destroy
    authorize @story
    @story.destroy!
    respond_with_streams(message: "Story was successfully deleted.")
  end

  def move
    authorize @story
    if @story.update(move_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def autosave
    authorize @story, :update?

    if @story.update(permitted_attributes(@story))
      head :ok
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  private

  def respond_with_streams(message:)
    render turbo_stream: [
      turbo_stream.update("modal", ""),
      turbo_stream.append("flash-container", Components::Shared::Toast.new(type: :success, message: message))
    ]
  end

  def render_form_with_errors
    render Components::Stories::Form.new(story: @story, current_project: @project), status: :unprocessable_content
  end

  def set_project
    @project = policy_scope(Project).find(params[:project_id])
  end

  def set_board
    @board = @project.boards.find(params[:board_id])
  end

  def set_story
    @story = policy_scope(@project.stories).friendly.find(params[:id])
  end

  def set_story_for_move
    @story = policy_scope(@project.stories).friendly.find(params[:id])
  end

  def move_params
    params.require(:story).permit(:board_id, :position)
  end
end
