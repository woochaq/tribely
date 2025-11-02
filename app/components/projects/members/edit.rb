class Components::Projects::Members::Edit < Components::Base
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::TurboFrameTag

  attr_reader :project_user

  def initialize(project_user:)
    @project_user = project_user
  end

  def view_template
    turbo_frame_tag project_user do
      li(class: "p-4 flex items-center justify-between") do
        simple_form_for([ project_user.project, project_user ], url: project_member_path(project_user.project, project_user), method: :patch) do |f|
          div(class: "flex items-center gap-x-4 w-full") do
            render Components::Shared::Avatar.new(user: project_user.user, url: nil, size: "w-10 h-10")

            div(class: "flex-grow flex items-center gap-x-4") do
              div(class: "flex-grow") do
                f.input :email, input_html: { value: project_user.user.email, disabled: true }, label: false
              end
              div(class: "w-48") do
                f.input :role, collection: ProjectUser.roles.keys.map { |r| [ r.humanize, r ] }, label: false, include_blank: false
              end
              f.button :submit, "Save", class: "btn-primary"
            end
          end
        end
      end
    end
  end
end
