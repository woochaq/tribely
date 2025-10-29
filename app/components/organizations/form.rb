class Components::Organizations::Form < Components::Base
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::LinkTo
  include SimpleForm::ActionViewExtensions::FormHelper

  def initialize(organization:)
    @organization = organization
  end

  def view_template
    div(class: "max-w-2xl mx-auto bg-mantle p-8 rounded-2xl border border-crust shadow-lg") do
      simple_form_for(@organization) do |f|
        div(class: "space-y-6") do
          f.input :name, autofocus: true

          div(class: "flex items-center justify-end gap-4 pt-4 border-t border-crust mt-6") do
            link_to "Cancel", organizations_path, class: "btn-secondary"
            f.button :submit, "Update Organization", class: "btn-primary"
          end
        end
      end
    end
  end
end
