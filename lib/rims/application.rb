require 'bundler'
require 'journey'
require 'singleton'

module Rims
  class Application
    include Singleton

    class << self
      attr_accessor :root

      def call(env)
        instance.call(env)
      end
    end

    def initialize
      load_controllers
      build_routes
    end

    def build_routes
      routes = Journey::Routes.new
      Controller.each do |controller|
        controller.endpoints.each do |endpoint|
          strexp = Journey::Router::Strexp.new endpoint.path, {}, ["/.?"]
          path = Journey::Path::Pattern.new strexp
          routes.add_route controller, path, {request_method: endpoint.verb}, {}
        end
      end
      @router = Journey::Router.new routes, {}
    end

    def root
      self.class.root
    end

    def load_controllers
      Dir.glob("#{root}/controllers/**/*.rb").sort.each { |file| require file }
    end

    def call(env)
      @router.call(env)
    end
  end
end