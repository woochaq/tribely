module Views
  module Errors
    class NotLoggedNotFound < Views::Base
      def view_template
        render Components::Errors::NotFound
      end
    end
  end
end
