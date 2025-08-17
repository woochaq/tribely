class Components::App::Board < Components::Base
  # Fake data for demonstration
  def initial_board_data
    {
      backlog: [
        {id: 1, title: "Design the new landing page"},
        {id: 2, title: "Develop user authentication"},
        {id: 3, title: "Set up the CI/CD pipeline"}
      ],
      in_progress: [
        {id: 4, title: "Refactor the database schema"}
      ],
      done: [
        {id: 5, title: "Choose a CSS framework"},
        {id: 6, title: "Initialize the Rails application"}
      ]
    }
  end

  def view_template
    main(class: "flex-1 flex flex-col p-4 sm:p-6 lg:p-8 overflow-hidden") do
      # Board header (e.g., for filters or view options)
      div(class: "flex-shrink-0 mb-6") do
        h1(class: "text-2xl font-bold text-text") { "Project Kanban Board" }
        # Filters could go here
      end

      # Main board container with horizontal scroll
      div(class: "flex-1 overflow-x-auto") do
        div(class: "inline-flex h-full gap-6") do
          # Render columns from data
          render_column(title: "Backlog", tasks: initial_board_data[:backlog], color: "border-subtext0")
          render_column(title: "In Progress", tasks: initial_board_data[:in_progress], color: "border-yellow")
          render_column(title: "Done", tasks: initial_board_data[:done], color: "border-green")
        end
      end
    end
  end

  private

  def render_column(title:, tasks:, color:)
    div(class: "flex flex-col w-80 h-full") do
      # Column Header
      div(class: "flex items-center justify-between px-3 py-2 flex-shrink-0") do
        h2(class: "text-md font-semibold text-text") do
          span { title }
          span(class: "ml-2 text-sm font-normal text-subtext0") { tasks.count }
        end
        # Column menu icon (e.g., three dots)
        button(class: "p-1 text-subtext0 hover:text-text") { "..." }
      end

      # Cards Container
      div(class: "flex-1 overflow-y-auto p-1") do
        div(class: "space-y-3") do
          tasks.each do |task|
            render_task_card(task)
          end
        end
      end
    end
  end

  def render_task_card(task)
    div(class: "bg-surface0 border border-crust rounded-lg p-3 shadow-sm hover:bg-surface1 cursor-pointer") do
      p(class: "font-semibold text-text") { task[:title] }
      # You can add more details here like assignee, tags, etc.
      div(class: "flex items-center justify-between mt-4") do
        span(class: "text-xs text-subtext0") { "TBLY-#{task[:id]}" }
        # Assignee placeholder
        div(class: "w-6 h-6 rounded-full bg-blue/50 flex items-center justify-center text-xs font-bold text-crust") { "W" }
      end
    end
  end
end
