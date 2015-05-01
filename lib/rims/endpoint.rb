require 'journey'

module Rims
  class Endpoint
    attr_reader :verb, :path

    def initialize(verb, path, options={})
      options = normalize_options(options)
      @verb = verb
      @path = path
      @compiled = compile(path, options)
    end

    def mount(controller, routes)
      routes.add_route controller, @compiled, {request_method: verb.to_s.upcase}, {}
    end

    private

    def normalize_options(options)
      defaults = {
        requirements: {},
        separators: ["/.?"],
        anchor: true
      }
      defaults.update(options)
    end

    def compile(path, options)
      requirements, separators, anchor = options.values_at(:requirements, :separators, :options)
      strexp = Journey::Router::Strexp.new path, requirements, separators, anchor
      Journey::Path::Pattern.new strexp
    end
  end
end