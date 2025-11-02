class Views::Projects::Settings::Show < Views::Projects::Base
  def view_template
    super do
      render Components::Projects::UserList.new(project: @project)
    end
  end
end
