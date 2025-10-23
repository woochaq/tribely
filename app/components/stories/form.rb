class Components::Stories::Form < Components::Base
  include Phlex::Rails::Helpers::FormFor
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::T

  def initialize(story:, current_project: nil)
    @story = story
    @current_project = current_project
  end

  def view_template
    render Components::Shared::Modal.new(base_url: project_path(@current_project)) do
      simple_form_for([ @current_project, @story ]) do |f|
        div(class: "grid grid-cols-1 lg:grid-cols-3 lg:gap-8") do
          div(class: "lg:col-span-2 space-y-6") do
            f.input :board_id, as: :hidden
            f.input :title
            f.rich_text_area :description, class: "bg-white lexxy-content wysiwyg-editor"
          end
          div(class: "space-y-6") do
            f.input :story_type, as: :select, collection: translated_story_types, include_blank: false
            f.association :owner, collection: @current_project.users, prompt: "Choose user"
            f.association :user, collection: @current_project.users, prompt: "Choose user"
            f.input :status, as: :select, collection: translated_statuses, include_blank: false

            div(class: "flex items-center justify-end gap-4 pt-4") do
              if @story.persisted?
                link_to "Destroy", project_story_path(@current_project, @story), class: "btn-warn", data: { turbo_method: :delete }
              end
              f.button :submit, class: "btn-primary"
            end
          end
        end
      end
    end
  end

  private

  def translated_story_types
    ::Story.story_types.keys.map { |type| [ t("activerecord.attributes.story.story_types.#{type}"), type ] }
  end

  def translated_statuses
    ::Story.statuses.keys.map { |status| [ t("activerecord.attributes.story.statuses.#{status}"), status ] }
  end
end
