class Views::Organizations::Edit < Views::Organizations::Base
  def initialize(organization:)
    @organization = organization
  end

  def view_template
    super do
      render Components::Organizations::Form.new(organization: @organization)
    end
  end

  def page_title
    "My Organizations / #{@organization.name} / Edit"
  end
end
