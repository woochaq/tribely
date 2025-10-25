class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_story
  before_action :set_comment, only: [ :update, :destroy ]

  def new
    @comment = Comment.new(user: current_user, story: @story)
    render Components::Comments::Form.new(story: @story, comment: @comment)
  end

  def create
    @comment = @story.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend(helpers.dom_id(@story, "comments"), Components::Comments::Comment.new(comment: @comment)),
            turbo_stream.update(helpers.dom_id(@story, "new_comment_form"), Components::Comments::Form.new(story: @story, comment: Comment.new))
          ]
        end
        format.html { redirect_to project_story_path(@current_project, @story), notice: "Comment was successfully created." }
      end
    else
      render_form_with_errors
    end
  end

  def update
    if @comment.update(comment_params)
      message = "Comment was successfully updated."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(@comment, Components::Comments::Comment.new(comment: @comment)),
            turbo_stream.append("flash-container", Components::Shared::Toast.new(type: :success, message: message))
          ]
        end
        format.html { redirect_to project_story_path(@current_project, @story), notice: message }
      end
    else
      render_form_with_errors
    end
  end

  def destroy
    @comment.destroy!
    message = "Comment was sucessfully destroyed."
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
            turbo_stream.remove(@comment),
            turbo_stream.append("flash-container", Components::Shared::Toast.new(type: :success, message: message))
        ]
      end
      format.html { redirect_to project_story_path(@current_project, @story), notice: message }
    end
  end

  private

  def render_form_with_errors
    render Components::Comments::Form.new(story: @story, comment: @comment), status: :unprocessable_content
  end

  def set_project
    @current_project = current_user.projects.find(params[:project_id])
  end

  def set_story
    @story = @current_project.stories.find(params[:story_id])
  end

  def set_comment
    @comment = @story.comments.where(user: current_user).find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
