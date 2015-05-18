require 'erubis'

module Rims
  module Renderers
    class TemplateNotFound < StandardError; end;

    class ErbRenderer
      VALID_SOURCES = [:file, :string].freeze
      
      def initialize template: nil, locals: {}, source: :file
        @template = template_from_source template, source
        @locals = locals
      end

      def render
        @template.result @locals
      end

      private

      def valid_source? source
        VALID_SOURCES.include? source
      end

      def template_from_source template, source
        unless valid_source? source
          raise ArgumentError, "Source must be one of #{VALID_SOURCES}"
        end

        content = if source == :file
          template_from_file template
        else
          template
        end

        Erubis::Eruby.new content
      end

      def template_from_file path
        if File.exist? path
          File.read path
        else
          raise TemplateNotFound
        end
      end
    end
  end
end