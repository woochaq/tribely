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
    render Views::Stories::ShowView.new(story: @story, board: @board, current_project: @current_project)
  end

  def new
    @story = @board.stories.build
    render Views::Stories::NewView.new(story: @story, board: @board, current_project: @current_project)
  end

  def edit
    render Views::Stories::EditView.new(story: @story, board: @board, current_project: @current_project)
  end

  def create
    @story = @board.stories.build(story_params)
    @story.owner = current_user

    if @story.save
      redirect_to project_board_story_path(@current_project, @board, @story), notice: "Story was successfully created."
    else
      render Views::Stories::NewView.new(story: @story, board: @board, current_project: @current_project), status: :unprocessable_content
    end
  end

  def update
    if @story.update(story_params)
      redirect_to project_board_story_path(@current_project, @board, @story), notice: "Story was successfully updated."
    else
      render Views::Stories::EditView.new(story: @story, board: @board, current_project: @current_project), status: :unprocessable_content
    end
  end

  def destroy
    @story.destroy!
    redirect_to project_board_stories_path(@current_project, @board), notice: "Story was successfully destroyed."
  end

  private

  def set_project
    @board = current_user.projects.find(params[:project_id])
    @current_project = @board
  end

  def set_board
    @board = @board.boards.find(params[:board_id])
  end

  def set_story
    @story = @board.stories.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:board_id, :title, :description, :status, :story_type)
  end
end
