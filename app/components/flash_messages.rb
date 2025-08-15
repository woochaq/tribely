class Components::FlashMessages < Components::Base
  include Phlex::Rails::Helpers::Flash

  def view_template
    flash.each do |type, message|
      p(class: type.to_s) { message } # np. class="notice" lub class="alert"
    end
  end
end
