class Components::Organizations::Members::Edit < Components::Base
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::TurboFrameTag

  attr_reader :organization_user

  def initialize(organization_user:)
    @organization_user = organization_user
  end

  def view_template
    turbo_frame_tag organization_user do
      li(class: "p-4 flex items-center justify-between hover:bg-surface0") do
        simple_form_for([ organization_user.organization, organization_user ], url: organization_member_path(organization_user.organization, organization_user), method: :patch, html: { class: "w-full" }) do |f|
          div(class: "flex items-center gap-x-2 w-full") do
            render Components::Shared::Avatar.new(user: organization_user.user, url: nil, size: "w-10 h-10")

            div(class: "flex-grow flex items-center gap-x-2") do
              div(class: "flex-grow") do
                f.input :email, input_html: { value: organization_user.user.email, disabled: true }, label: false
              end
              div(class: "w-48") do
                f.input :role, collection: OrganizationUser.roles.keys.map { |r| [ r.humanize, r ] }, label: false, include_blank: false
              end
              f.button :submit, "Save", class: "btn-primary"
            end
          end
        end
      end
    end
  end
end
