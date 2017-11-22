module Sphynx
  class Configuration
    attr_reader :dispatch_routes, :revoke_routes

    METHODS = %w[HEAD GET POST PUT PATCH DELETE OPTIONS]

    def initialize
      @dispatch_routes = []
      @revoke_routes = []
    end

    def dispatch_routes=(routes)
      validate_routes_config!(routes)
      @dispatch_routes = routes
    end

    def revoke_routes=(routes)
      validate_routes_config!(routes)
      @revoke_routes = routes
    end

    private

    def validate_routes_config!(routes)
      raise ArgumentError, 'Dispatch and revoke routes should be an array' unless routes.is_a?(Array)
      raise ArgumentError, 'All dispatch and revoke routes elements should have the form [HTTP_VERB, regex]' unless routes.all? { |route| route.length == 2 && METHODS.include?(route[0]) && route[1].is_a?(Regexp) }
    end
  end
end
