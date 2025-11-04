module Views
  module Errors
    class LoggedNotFound < Views::App::Base
      def view_template
        render Components::Errors::NotFound
      end
    end
  end
end
