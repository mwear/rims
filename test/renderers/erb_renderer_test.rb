require 'test_helper'
require 'rims/renderers/erb_renderer'

module Rims
  module Renderers
    class ErbRendererTest < Minitest::Test
      TEMPLATES_PATH = File.expand_path File.join(File.dirname(__FILE__), '../fixtures/templates')

      def test_renders_content_from_string_template
        template = "Hello <%= name %>!"
        renderer = ErbRenderer.new template: template, locals: {:name => "World"}, source: :string
        assert_equal "Hello World!", renderer.render
      end

      def test_renders_content_from_file_template
        path = File.join TEMPLATES_PATH, 'test.erb'
        renderer = ErbRenderer.new template: path, locals: {:name => "World"}
        assert_equal "Hello World!", renderer.render
      end

      def test_raises_error_with_unkown_source
        assert_raises ArgumentError do
          ErbRenderer.new template: "<%= blah %>", source: :this_is_not_valid
        end
      end

      def test_raises_error_with_unkown_source
        assert_raises TemplateNotFound do
          ErbRenderer.new template: "/this/template/does/not/exist"
        end
      end
    end
  end
end