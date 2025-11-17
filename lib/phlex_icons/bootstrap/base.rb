# frozen_string_literal: true

module PhlexIcons
  module Bootstrap
    class Base < Phlex::SVG
      attr_reader :attrs

      def initialize(**attrs)
        @attrs = attrs
      end
    end
  end
end
