class Views::Home::Index < Views::Base
  def page_title
    "Tribely - Your projects management platform"
  end

  def view_template
    render Components::LandingPage::HeroSection
    render Components::LandingPage::FeaturesSection
    render Components::LandingPage::PricingSection
  end
end
