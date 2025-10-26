class Components::Shared::Modal < Components::Base
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::ButtonTag

  def initialize(base_url: nil, should_update_url: false)
    @base_url = base_url
    @should_update_url = should_update_url
  end

  def view_template(&)
    turbo_frame_tag "modal" do
      if block_given?
        # Modal Backdrop
        div(
          class: "fixed inset-0 z-50 bg-mantle/50 flex items-center justify-center p-4",
          data: {
            controller: "turbo-modal",
            action: "click->turbo-modal#hideModal:self keydown.esc@window->turbo-modal#hideModal",
            "turbo-modal-base-url-value": @base_url,
            "turbo-modal-should-update-url-value": @should_update_url
          }
        ) do
          # Modal content
          div(
            class: "relative bg-mantle rounded-2xl shadow-lg border border-crust p-6 w-full max-w-lg lg:max-w-7xl max-h-[95vh] overflow-y-auto",
          ) do
            button(class: "absolute top-4 right-4 cursor-pointer", data: { action: "click->turbo-modal#hideModal" }) { render Components::Icons::XMark }
            yield
          end
        end
      end
    end
  end
end
