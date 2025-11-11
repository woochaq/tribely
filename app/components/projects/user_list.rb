class Components::Projects::UserList < Components::Base
  include Pundit::Authorization
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::TimeAgoInWords

  attr_reader :project

  def initialize(project:)
    @project = project
  end

  def view_template
    div do
      if policy(project).add_member?
        render_add_member_form
      end

      div(class: "mt-8") do
        h2(class: "text-2xl font-bold tracking-tight text-text mb-4") { "Project Members" }
        div(class: "bg-mantle rounded-lg border border-crust shadow-lg") do
          ul(class: "divide-y divide-crust") do
            if project.project_users.any?
              project.project_users.includes(:added_by, user: [ :avatar_attachment ]).each do |project_user|
                render Components::Projects::UserListItem.new(project_user: project_user)
              end
            else
              li(class: "p-4 text-subtext0") { "No members found in this project." }
            end
          end
        end
      end
    end
  end

  private

  def render_invitation_form
    div(class: "bg-mantle rounded-lg border border-crust shadow-lg p-6") do
      h2(class: "text-2xl font-bold tracking-tight text-text mb-4") { "Invite a new member" }
      simple_form_for([ @organization, Invitation.new ], url: organization_invitations_path(@organization), html: { class: "flex flex-col sm:flex-row items-start sm:items-end gap-4" }, data: { turbo_progress_bar: true }) do |f|
        f.input :email, wrapper_html: { class: "flex-grow w-full" }, autocomplete: "off", label: false, placeholder: "Enter email address"
        f.input :role, as: :select, collection: Invitation.roles.keys.map { |role| [ role.humanize, role ] }, include_blank: false, label: false, wrapper_html: { class: "w-full sm:w-48" }
        f.button :submit, "Send Invitation", class: "btn-primary w-full sm:w-auto"
      end
    end
  end

  def render_add_member_form
    div(class: "bg-mantle rounded-lg border border-crust shadow-lg p-6") do
      h2(class: "text-2xl font-bold tracking-tight text-text mb-4") { "Invite a new member" }
      simple_form_for([ project, ProjectUser.new ], url: project_members_path(project), html: { class: "flex flex-col sm:flex-row items-start sm:items-end gap-4" }, data: { turbo_progress_bar: true }) do |f|
        f.input :user_id, as: :select, collection: available_users_for_project.map { |u| [ u.name, u.id ] }, include_blank: true, label: false, wrapper_html: { class: "flex-grow w-full sm:w-48" }
        f.input :role, as: :select, collection: ProjectUser.roles.keys.map { |role| [ role.humanize, role ] }, include_blank: false, label: false, wrapper_html: { class: "w-full sm:w-48" }
        f.button :submit, "Add Member", class: "btn-primary w-full sm:w-auto"
      end
    end
  end

  def available_users_for_project
    project.organization.users.where.not(id: project.users.pluck(:id))
  end
end
