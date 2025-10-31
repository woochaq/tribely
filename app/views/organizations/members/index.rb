class Views::Organizations::Members::Index < Views::Organizations::Base
  def view_template
    super do
      render Components::Organizations::UserList.new(organization: @organization)
    end
  end
end
