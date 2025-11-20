module Views
  module Docs
    class Show < Views::Base
      def view_template
        div(class: "container mx-auto px-4 sm:px-6 lg:px-8 py-8") do
          header_section

          user_context_section

          roles_section
          stories_section
          shortcuts_section
          webhooks_section
        end
      end

      private

      def header_section
        div(class: "mb-16 text-center") do
          div(class: "text-6xl mb-4") { "📚" }
          h1(class: "text-4xl font-bold text-text mb-4") { "Tribely Guide" }
          p(class: "text-xl text-subtext0") { "Everything you need to know about managing your projects." }
        end
      end

      def user_context_section
        title = current_user ? "Your Context" : "Context (Example)"
        icon = current_user ? "👤" : "👀"

        render Components::Docs::Section.new(title, icon: icon) do
          div(class: "grid grid-cols-1 md:grid-cols-2 gap-6") do
            # Organizations
            div(class: "bg-mantle border border-crust rounded-lg p-6 shadow-sm relative overflow-hidden") do
              unless current_user
                div(class: "absolute top-0 right-0 bg-yellow-100 text-yellow-800 text-[10px] px-2 py-1 font-bold uppercase tracking-wider rounded-bl-lg") { "Demo Data" }
              end

              h3(class: "font-semibold text-text mb-4 flex items-center gap-2") do
                plain "🏢 Organizations"
                count = current_user ? current_user.organizations.count : 1
                span(class: "bg-surface0 text-subtext0 px-2 py-0.5 rounded-full text-xs") { count }
              end

              ul(class: "space-y-2") do
                if current_user
                  if current_user.organizations.any?
                    current_user.organization_users.includes(:organization).each do |org_user|
                      render_context_row(org_user.organization.name, org_user.role)
                    end
                  else
                    p(class: "text-sm text-subtext0 italic") { "You are not a member of any organization." }
                  end
                else
                  # Demo data
                  render_context_row("Acme Corp", :owner)
                end
              end
            end

            # Projects
            div(class: "bg-mantle border border-crust rounded-lg p-6 shadow-sm relative overflow-hidden") do
              unless current_user
                div(class: "absolute top-0 right-0 bg-yellow-100 text-yellow-800 text-[10px] px-2 py-1 font-bold uppercase tracking-wider rounded-bl-lg") { "Demo Data" }
              end

              h3(class: "font-semibold text-text mb-4 flex items-center gap-2") do
                plain "🚀 Projects"
                count = current_user ? current_user.projects.count : 2
                span(class: "bg-surface0 text-subtext0 px-2 py-0.5 rounded-full text-xs") { count }
              end

              ul(class: "space-y-2") do
                if current_user
                  if current_user.projects.any?
                    current_user.project_users.includes(:project).each do |proj_user|
                      render_context_row(proj_user.project.name, proj_user.role)
                    end
                  else
                    p(class: "text-sm text-subtext0 italic") { "You are not assigned to any projects." }
                  end
                else
                  # Demo data
                  render_context_row("Mobile App Launch", :member)
                  render_context_row("Website Redesign", :owner)
                end
              end
            end
          end
        end
      end

      def render_context_row(name, role)
        li(class: "flex items-center justify-between text-sm text-text") do
          span { name }
          role_badge(role)
        end
      end

      def roles_section
        render Components::Docs::Section.new("Roles & Permissions", icon: "🛡️") do
          div(class: "grid grid-cols-1 md:grid-cols-2 gap-8") do
            div do
              h3(class: "font-semibold text-text mb-3") { "Organization Roles" }
              ul(class: "space-y-3 text-sm text-subtext0") do
                li do
                  render Components::Docs::Badge.new(color: :purple) { "Owner" }
                  span { "Full access. Can manage billing, members, and all projects." }
                end
                li do
                  render Components::Docs::Badge.new(color: :blue) { "Member" }
                  span { "Can view and work on assigned projects. Cannot manage organization billing." }
                end
                li do
                  render Components::Docs::Badge.new(color: :gray) { "Guest" }
                  span { "Limited access. Can only see specific projects they are invited to." }
                end
              end
            end

            div do
              h3(class: "font-semibold text-text mb-3") { "Project Roles" }
              ul(class: "space-y-3 text-sm text-subtext0") do
                li do
                  render Components::Docs::Badge.new(color: :purple) { "Owner" }
                  span { "Can manage project settings, webhooks, and members." }
                end
                li do
                  render Components::Docs::Badge.new(color: :blue) { "Member" }
                  span { "Can create and edit stories, comments, and view documents." }
                end
                 li do
                  render Components::Docs::Badge.new(color: :gray) { "Guest" }
                  span { "Can only view stories and add comments. Cannot create or edit stories." }
                end
              end
            end
          end
        end
      end

      def stories_section
        render Components::Docs::Section.new("Stories & Workflow", icon: "📋") do
          div(class: "space-y-6") do
            div do
              h3(class: "font-semibold text-text mb-3") { "Story Types" }
              div(class: "flex flex-wrap gap-4") do
                story_type_card("Feature", PhlexIcons::Bootstrap::StarFill.new(class: "size-5 text-yellow-300"), "New functionality delivering value to users.", :green)
                story_type_card("Bug", PhlexIcons::Bootstrap::BugFill.new(class: "size-5 text-red-400"), "Fix for unintended behavior or defects.", :red)
                story_type_card("Chore", PhlexIcons::Bootstrap::WrenchAdjustable.new(class: "size-5 text-gray-400"), "Technical work, maintenance, or refactoring.", :gray)
                story_type_card("Spike", PhlexIcons::Bootstrap::Search.new(class: "size-5 text-yellow-300"), "Research or exploration to reduce uncertainty.", :yellow)
              end
            end

            div do
              h3(class: "font-semibold text-text mb-3") { "Workflow Statuses" }
              div(class: "flex items-center gap-2 text-sm overflow-x-auto py-2") do
                status_step("To Do", "Planned work.", :gray)
                arrow
                status_step("In Progress", "Currently being worked on.", :blue)
                arrow
                status_step("In Review", "Awaiting code review or QA.", :yellow)
                arrow
                status_step("Done", "Completed and accepted.", :green)
              end
            end

            render Components::Docs::Callout.new(icon: "📥", color: :blue, title: "Auto-Archiving") do
              "Stories in the 'Done' column are automatically archived after a set period to keep the board clean. You can always access them in the Archive view."
            end

             render Components::Docs::Callout.new(icon: "▶️", color: :green, title: "Starting a Story") do
              "Starting a story (moving it to 'In Progress') automatically assigns it to you."
            end
          end
        end
      end

      def shortcuts_section
        render Components::Docs::Section.new("Power Features", icon: "⚡ ") do
          div(class: "grid grid-cols-1 md:grid-cols-2 gap-6") do
            div do
              h3(class: "font-semibold text-text mb-3") { "Mentions & References" }
              ul(class: "space-y-2 text-sm text-subtext0") do
                li do
                  render Components::Docs::Kbd.new { "@" }
                  span { "Mention a team member to notify them." }
                end
                li do
                  render Components::Docs::Kbd.new { "#" }
                  span { "Reference another story by ID." }
                end
                li do
                   render Components::Docs::Kbd.new { "^" }
                   span { "Link to a document." }
                end
              end
            end

             div do
              h3(class: "font-semibold text-text mb-3") { "Editor" }
              ul(class: "space-y-2 text-sm text-subtext0") do
                li do
                   span(class: "text-green-600 font-medium") { "Autosave" }
                   span { " • Content saves automatically after 1 second of inactivity." }
                end
              end
            end
          end
        end
      end

      def webhooks_section
        render Components::Docs::Section.new("Integrations", icon: "🔌") do
          div(class: "space-y-4") do
            p(class: "text-subtext0") { "Tribely provides inbound webhooks to automatically create stories from external sources (e.g., support forms, error trackers, or CI pipelines)." }

              div do
              h4(class: "font-semibold text-text mb-2") { "Supported Actions" }
              ul(class: "list-disc list-inside text-sm text-subtext0 ml-2") do
                li { "Create Story" }
              end
            end

            div do
              h4(class: "font-semibold text-text mb-2") { "Usage" }
              p(class: "text-sm text-subtext0 mb-2") { "Send a POST request to your unique webhook URL. The payload data will be used to populate the story." }

              div(class: "bg-crust p-4 rounded-md border border-mantle font-mono text-xs overflow-x-auto text-subtext1 mb-4") do
                plain "curl -X POST https://tribely.work/api/webhooks/<YOUR_TOKEN> \\"
                br
                plain "  -H 'Content-Type: application/json' \\"
                br
                plain "  -d '{\"title\": \"Fix login bug\", \"description\": \"User cannot login...\", \"story_type\": \"bug\"}'"
              end

              p(class: "text-sm text-subtext0 mb-1") do
                plain "Available "
                code_badge("story_type")
                plain " values:"
              end
              ul(class: "list-disc list-inside text-sm text-subtext0 ml-2") do
                li do
                  code_badge("feature")
                  plain " (default)"
                end
                li { code_badge("bug") }
                li { code_badge("chore") }
                li { code_badge("spike") }
              end
            end

            div(class: "mt-4") do
              render Components::Docs::Callout.new(icon: "🔒", color: :yellow, title: "Access Restricted") do
                "Webhook configuration (generating tokens) is available only to Project Owners."
              end
            end
          end
        end
      end

      def code_badge(text)
        code(class: "bg-surface0 px-1 rounded border border-crust font-mono text-xs") { text }
      end

      # Helpers
      def role_badge(role)
        color = case role.to_sym
        when :owner then :purple
        when :member then :blue
        else :gray
        end
        render Components::Docs::Badge.new(color: color) { role.to_s.humanize }
      end

      def story_type_card(name, icon, desc, color)
        div(class: "border border-crust rounded p-3 flex-1 min-w-[140px] bg-mantle") do
          div(class: "flex items-center gap-2 mb-2 font-medium text-text") do
            render icon
            span { name }
          end
          p(class: "text-xs text-subtext0") { desc }
        end
      end

      def status_step(name, desc, color)
        div(class: "flex flex-col items-center text-center min-w-[100px]") do
          render Components::Docs::Badge.new(color: color) { name }
          span(class: "text-[10px] text-subtext0 mt-1") { desc }
        end
      end

      def arrow
        span(class: "text-subtext0") { "→" }
      end
    end
  end
end
