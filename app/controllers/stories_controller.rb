class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_board
  before_action :set_story, only: %i[show edit update destroy]

  def index
    @stories = @board.stories
    render Views::Stories::IndexView.new(stories: @stories, board: @board, current_project: @current_project)
  end

  def show
    render Components::Stories::Form.new(story: @story, board: @board, current_project: @current_project)
  end

  def new
    @story = @board.stories.build
    @story.owner = current_user
    render Components::Stories::Form.new(story: @story, board: @board, current_project: @current_project)
  end

  def edit
    render Components::Stories::Form.new(story: @story, board: @board, current_project: @current_project)
  end

  def create
    @story = @board.stories.build(story_params)
    @story.owner = current_user

    if @story.save
      respond_with_streams(message: "Story was successfully created.")
    else
      render_form_with_errors
    end
  end

  def update
    if @story.update(story_params)
      respond_with_streams(message: "Story was successfully updated.")
    else
      render_form_with_errors
    end
  end

  def destroy
    @story.destroy!
    respond_with_streams(message: "Story was successfully deleted.")
  end

  private

  def respond_with_streams(message:)
    render turbo_stream: [
      turbo_stream.update("modal", ""),
      turbo_stream.append("flash-container",
        Components::Shared::Toast.new(type: :success, message: message))
    ]
  end

  def render_form_with_errors
    render Components::Stories::Form.new(story: @story, board: @board, current_project: @current_project), status: :unprocessable_content
  end

  def set_project
    @current_project = current_user.projects.find(params[:project_id])
  end

  def set_board
    @board = @current_project.boards.find(params[:board_id])
  end

  def set_story
    @story = @board.stories.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:board_id, :user_id, :owner_id, :title, :description, :status, :story_type)
  end
end
