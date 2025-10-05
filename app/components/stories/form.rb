class Components::Stories::Form < Components::Base
  include Phlex::Rails::Helpers::FormFor
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::ButtonTo

  def initialize(story:, board: @board, current_project: nil)
    @story = story
    @board = board
    @current_project = current_project
  end

  def view_template
    render Components::Shared::Modal do
      simple_form_for([ @current_project, @board, @story ]) do |f|
        div(class: "grid grid-cols-1 lg:grid-cols-3 lg:gap-8") do
          div(class: "lg:col-span-2 space-y-6") do
            # f.input :board_id, as: :hidden, value: @board.id
            f.association :board, collection: @current_project.boards
            f.input :title
            f.input :description, as: :text, input_html: { rows: 10 }
          end
          div(class: "space-y-6") do
            f.association :owner, collection: @current_project.users, prompt: "Choose user"
            f.association :user, collection: @current_project.users, prompt: "Choose user"
            f.input :status, as: :select, collection: ::Story.statuses.keys
            f.input :story_type, as: :select, collection: ::Story.story_types.keys

            div(class: "flex items-center justify-end gap-4 pt-4") do
              if @story.persisted?
                link_to "Destroy", project_board_story_path(@current_project, @board, @story), class: "btn-warn", data: { turbo_method: :delete }
              end
              f.button :submit, class: "btn-primary"
            end
          end
        end
      end
    end
  end
end
