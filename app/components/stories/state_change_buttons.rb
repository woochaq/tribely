# frozen_string_literal: true

class Components::Stories::StateChangeButtons < Components::Base
  include Pundit::Authorization
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::T
  include Components::Shared::StoryStatusColors

  def initialize(story:, current_project:, current_board:)
    @story = story
    @current_project = current_project
    @current_board = current_board
  end

  def view_template
    div(class: "flex items-center gap-2") do
      case @story.status
      when "todo"
        if @current_board
          link_to "Start", project_story_path(@current_project, @story, story: { status: :in_progress, board_id: @current_board.id, user_id: current_user.id }, state_change: true), class: "btn #{button_color_classes(@story.status)} text-sm", data: { turbo_method: :patch }
        end
      when "in_progress"
        link_to "Review", project_story_path(@current_project, @story, story: { status: :in_review }, state_change: true), class: "btn #{button_color_classes(@story.status)} text-sm", data: { turbo_method: :patch }
      when "in_review"
        link_to "Accept", project_story_path(@current_project, @story, story: { status: :done }, state_change: true), class: "btn #{button_color_classes(@story.status)} text-sm", data: { turbo_method: :patch }
        link_to "Reject", project_story_path(@current_project, @story, story: { status: :in_progress }, state_change: true), class: "btn btn-warn text-sm", data: { turbo_method: :patch }
      when "done"
        link_to "Archive", project_story_path(@current_project, @story, story: { status: :archived }, state_change: true), class: "btn #{button_color_classes(@story.status)} text-sm", data: { turbo_method: :patch }
        link_to "Restart", project_story_path(@current_project, @story, story: { status: :todo, board_id: @current_board.id }, state_change: true), class: "btn btn-warn text-sm", data: { turbo_method: :patch }
      when "archived"
        link_to "Restart", project_story_path(@current_project, @story, story: { status: :todo, board_id: @current_board.id }, state_change: true), class: "btn btn-warn text-sm", data: { turbo_method: :patch }
      end
    end
  end
end
