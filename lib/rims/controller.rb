require 'rack'
require 'rims/endpoint'
require 'rims/language_extensions/module'
require 'rims/language_extensions/class'

module Rims
  class Controller
    attr_class :_action, :writer => false
    attr_class :endpoints, :default => [], :writer => false

    @registry = []

    class << self
      attr_reader :registry
      attr_func :description

      def inherited(subclass)
        registry << subclass
      end

      def each(&blk)
        registry.each(&blk)
      end

      def action(&blk)
        @_action = blk
      end

      def route(verb, path)
        endpoints << Endpoint.new(verb, path)
      end

      def call(env)
        new(env).call
      end

      def mount_endpoints(routes)
        endpoints.each { |e| e.mount(self, routes) }
      end
    end

    attr_reader :request
    attr_func :status, :headers, :body

    def initialize(env)
      @request = Rack::Request.new(env)
      status 200
      body nil
      headers Hash.new
    end

    def params
      @params ||= request.GET.merge(request.POST)
    end

    def call
      result = instance_eval(&self.class._action)
      body(result) if !body && result.is_a?(String)
      [status, headers, [body || ""]]
    end

    def render(body, opts = {})
      status(opts[:status]) if opts[:status]
      headers(opts[:headers]) if opts[:headers]
      body
    end
  end
end
