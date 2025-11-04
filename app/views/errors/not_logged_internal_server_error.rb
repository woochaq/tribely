module Views
  module Errors
    class NotLoggedInternalServerError < Views::Base
      def view_template
        render Components::Errors::InternalServerError
      end
    end
  end
end
