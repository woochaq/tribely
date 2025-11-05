class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_story
  before_action :set_comment, only: [ :update, :destroy, :edit, :show ]

  def show
    authorize @comment
    render Components::Comments::Comment.new(comment: @comment, current_user: current_user)
  end

  def new
    @comment = Comment.new(user: current_user, story: @story)
    authorize @comment
    render Components::Comments::Form.new(story: @story, comment: @comment)
  end


  def edit
    authorize @comment
    render Components::Comments::EditForm.new(story: @story, comment: @comment)
  end

  def create
    @comment = @story.comments.new(permitted_attributes(Comment))
    @comment.user = current_user
    authorize @comment

    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend(helpers.dom_id(@story, "comments"), Components::Comments::Comment.new(comment: @comment, current_user: current_user)),
            turbo_stream.update(helpers.dom_id(@story, "new_comment_form"), Components::Comments::NewCommentPlaceholder.new(story: @story)),
            turbo_stream.append("flash-container", Components::Shared::Toast.new(type: :success, message: "Comment was successfully created."))
          ]
        end
        format.html { redirect_to project_story_path(@current_project, @story), notice: "Comment was successfully created." }
      end
    else
      render_form_with_errors
    end
  end

  def update
    authorize @comment
    if @comment.update(permitted_attributes(@comment))
      message = "Comment was successfully updated."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("flash-container", Components::Shared::Toast.new(type: :success, message: message))
        end
        format.html { redirect_to project_story_path(@current_project, @story), notice: message }
      end
    else
      render_form_with_errors
    end
  end

  def destroy
    authorize @comment
    @comment.destroy!
    message = "Comment was sucessfully destroyed."
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("flash-container", Components::Shared::Toast.new(type: :success, message: message))
      end
      format.html { redirect_to project_story_path(@current_project, @story), notice: message }
    end
  end

  private

  def render_form_with_errors
    render Components::Comments::Form.new(story: @story, comment: @comment), status: :unprocessable_content
  end

  def set_project
    @current_project = policy_scope(Project).find(params[:project_id])
  end

  def set_story
    @story = @current_project.stories.friendly.find(params[:story_id])
  end

  def set_comment
    @comment = policy_scope(@story.comments).find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
