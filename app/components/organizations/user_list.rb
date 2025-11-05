class Components::Organizations::UserList < Components::Base
  include Pundit::Authorization
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::TimeAgoInWords

  def initialize(organization:)
    @organization = organization
    @pending_invitations = @organization.invitations.pending
  end

  def view_template
    div do
      if policy(Invitation.new(organization: @organization)).create?
        render_invitation_form
      end

      div(class: "mt-8") do
        h2(class: "text-2xl font-bold tracking-tight text-text mb-4") { "Organization Members" }
        div(class: "bg-mantle rounded-lg border border-crust shadow-lg") do
          ul(class: "divide-y divide-crust") do
            if @organization.organization_users.any?
              @organization.organization_users.includes(user: [ :avatar_attachment ]).each do |org_user|
                render Components::Organizations::UserListItem.new(organization_user: org_user)
              end
            else
              li(class: "p-4 text-subtext0") { "No members found in this organization." }
            end
          end
        end
      end

      if @pending_invitations.any?
        render_pending_invitations
      end
    end
  end

  private

  def render_invitation_form
    div(class: "bg-mantle rounded-lg border border-crust shadow-lg p-6") do
      h2(class: "text-2xl font-bold tracking-tight text-text mb-4") { "Invite a new member" }
      simple_form_for([ @organization, Invitation.new ], url: organization_invitations_path(@organization), html: { class: "flex flex-col sm:flex-row items-start sm:items-end gap-4" }, data: { turbo_progress_bar: true }) do |f|
        f.input :email, wrapper_html: { class: "flex-grow" }, autocomplete: "off", label: false, placeholder: "Enter email address"
        f.input :role, as: :select, collection: Invitation.roles.keys.map { |role| [ role.humanize, role ] }, include_blank: false, label: false, wrapper_html: { class: "w-full sm:w-48" }
        f.button :submit, "Send Invitation", class: "btn-primary w-full sm:w-auto"
      end
    end
  end

  def render_pending_invitations
    div(class: "mt-8 pending-invitations") do
      h2(class: "text-2xl font-bold tracking-tight text-text mb-4") { "Pending Invitations" }
      div(class: "bg-mantle rounded-lg border border-crust shadow-lg") do
        ul(class: "divide-y divide-crust") do
          @pending_invitations.each do |invitation|
            li(class: "p-4 flex justify-between items-center") do
              div do
                span(class: "text-text") { invitation.email }
                span(class: "text-xs text-subtext0 ml-2") { "Invited #{time_ago_in_words(invitation.created_at)} ago as #{invitation.role.humanize}" }
              end
              div(class: "flex items-center gap-2") do
                simple_form_for(invitation, url: resend_organization_invitation_path(@organization, invitation), method: :post) do |f|
                  f.submit "Resend", class: "btn-secondary"
                end
                simple_form_for([ @organization, invitation ], method: :delete, data: { turbo_confirm: "Are you sure you want to cancel this invitation?" }) do |f|
                  button(type: "submit", class: "text-subtext0 hover:text-danger cursor-pointer") do
                    render Components::Icons::Delete.new(class: "w-4 h-4 text-red")
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
