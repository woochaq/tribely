class Components::Stories::Form < Components::Base
  include Phlex::Rails::Helpers::FormFor
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::Routes

  def initialize(story:, board: @board, current_project: nil)
    @story = story
    @board = board
    @current_project = current_project
  end

  def view_template
    render Components::Shared::Modal do
      simple_form_for([ @current_project, @board, @story ]) do |f|
        div(class: "space-y-6") do
          f.input :board_id, as: :hidden, value: @board.id
          f.input :title, input_html: { class: "w-full p-2 border border-surface0 rounded-md bg-mantle" }
          f.input :description, as: :text, input_html: { rows: 4, class: "w-full p-2 border border-surface0 rounded-md bg-mantle" }
          f.input :status, as: :select, collection: ::Story.statuses.keys, input_html: { class: "w-full p-2 border border-surface0 rounded-md bg-mantle" }
          f.input :story_type, as: :select, collection: ::Story.story_types.keys, input_html: { class: "w-full p-2 border border-surface0 rounded-md bg-mantle" }

          div(class: "flex items-center justify-end gap-4 pt-4") do
            f.button :submit, class: "btn-primary"
          end
        end
      end
    end
  end
end
