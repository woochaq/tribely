class Components::Shared::Modal < Components::Base
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::ButtonTag

  def view_template(&)
    turbo_frame_tag "modal" do
      div(
        class: "bg-mantle p-8 rounded-2xl border border-crust shadow-lg shadow-crust/20",
        data: { controller: "turbo-modal" }
      ) do
        yield
        button_tag "Cancel", class: "btn-secondary", data: { action: "turbo-modal#hideModal" }
      end
    end
  end
end
