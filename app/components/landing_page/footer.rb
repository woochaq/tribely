class Components::LandingPage::Footer < Components::Base
  def view_template
    footer do
      div(class: "w-full px-6 py-8 text-center text-subtext0") do
        p { "© #{Time.now.year} Tribely. All rights reserved." }
      end
    end
  end
end
