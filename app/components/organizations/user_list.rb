class Components::Organizations::UserList < Components::Base
  def initialize(organization:)
    @organization = organization
  end

  def view_template
    div do
      div(class: "bg-mantle rounded-lg border border-crust shadow-lg") do
        ul(class: "divide-y divide-crust") do
          if @organization.organization_users.any?
            @organization.organization_users.includes(:user).each do |org_user|
              render Components::Organizations::UserListItem.new(organization_user: org_user)
            end
          else
            li(class: "p-4 text-subtext0") { "No members found in this organization." }
          end
        end
      end
    end
  end
end
