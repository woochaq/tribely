class Components::Shared::FlashMessages < Components::Base
  include Phlex::Rails::Helpers::Flash
  include Phlex::Rails::Helpers::TurboFrameTag

  def view_template
    turbo_frame_tag "flash-container", class: "fixed top-0 right-0 z-50 p-4 w-full max-w-sm" do
      flash.each do |type, message|
        render Components::Shared::Toast.new(type: type, message: message)
      end
    end
  end
end
