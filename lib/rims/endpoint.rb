module Rims
  class Endpoint
    attr_reader :path

    def initialize(verb, path)
      @verb = verb
      @path = path
    end

    def verb
      @verb.to_s.upcase
    end
  end
end