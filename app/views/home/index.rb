class Views::Home::Index < Views::Base
  def page_title
    "Tribely - Home page"
  end

  def view_template
    render Components::Home::HeroSection
    render Components::Home::FeaturesSection
    render Components::Home::PricingSection
  end
end
