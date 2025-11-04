module Views
  module Errors
    class LoggedInternalServerError < Views::App::Base
      def view_template
        render Components::Errors::InternalServerError
      end
    end
  end
end
