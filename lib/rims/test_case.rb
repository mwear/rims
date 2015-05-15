require 'minitest'
require 'rack/test'
require 'rims/language_extensions/module'

module Rims
  class TestCase < Minitest::Test
    class RoutingError < StandardError; end

    include Rack::Test::Methods

    class << self
      attr_func :tests
    end

    def app
      @app ||= self.class.tests
    end

    def allowed_http_verbs
      @allowed_http_verbs ||= app.endpoints.map(&:verb)
    end

    [:get, :post, :put, :patch, :delete].each do |verb|
      define_method verb do |*args|
        unless allowed_http_verbs.include? verb
          raise RoutingError, "Attempted to route to :#{verb}, but #{app} only routes to verbs: #{allowed_http_verbs}"
        end
        super(*args)
      end
    end
  end
end